import Factory
import Foundation
import Gzip
import JOSESwift

// MARK: - SdJWTDecoder

public class SdJWTDecoder: SdJWTDecoderProtocol {

  // MARK: Lifecycle

  public init(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) {
    self.dateDecodingStrategy = dateDecodingStrategy
  }

  // MARK: Public

  public enum DecoderError: Error {
    case invalidRawCredential
    case invalidJwtPayload
    case keyNotFound(_ key: String)
    case unknownDigestAlgorithm
    case digestNotFound
    case invalidStatusJWT
    case invalidStatusList
    case indexOutOfRange
  }

  public func decodeStatus(from jwt: JWT, at index: Int) throws -> Int {
    guard
      let jwtPayload = JWTDecoder().decodePayload(from: jwt.raw),
      let json = try JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any],
      let vc = json["vc"] as? [String: Any],
      let credentialSubject = vc["credentialSubject"] as? [String: Any],
      let encodedList = credentialSubject["encodedList"] as? String,
      let statusBytesList = Data(base64Encoded: encodedList.base64EncodedURLSafe)
    else {
      throw DecoderError.invalidStatusJWT
    }

    return try getByte(at: index, in: statusBytesList)
  }

  public func decodeDigests(from rawCredential: String) throws -> [SdJwtDigest] {
    let jws: JWS = try getJws(from: rawCredential)
    return try findSelectiveDisclosures(in: jws.payload.data())
  }

  public func decodeClaims(from rawCredential: String, digests: [SdJwtDigest]) throws -> [SdJWTClaim] {
    let sdJWTParts = rawCredential.separatedByDisclosures.map(String.init)
    let claims = try sdJWTParts[1...]
      .compactMap { disclosure -> SdJWTClaim? in
        guard
          let rawDisclosableClaim = disclosure.base64Decoded,
          let disclosableClaim = try? rawDisclosableClaim.toJsonObject() as? [Any]
        else { return nil }

        let jws = try getJws(from: rawCredential)
        let algo = try findAlgorithm(in: jws.payload.data())
        guard let digest = try findDigest(for: disclosure, in: digests, algorithm: algo) else {
          throw DecoderError.digestNotFound
        }
        return try .init(
          disclosableClaim: disclosableClaim,
          disclosure: disclosure,
          digest: digest)
      }
    return claims
  }

  public func decodeVerifiableCredential(from jwt: JWT) -> SdJWTVc? {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = dateDecodingStrategy

    guard
      let jwtPayload = JWTDecoder().decodePayload(from: jwt.raw),
      let json = try? JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any],
      let vcDictionnary = json["vc"] as? [String: Any],
      let data = try? JSONSerialization.data(withJSONObject: vcDictionnary),
      let vc = try? jsonDecoder.decode(SdJWTVc.self, from: data)
    else { return nil }
    return vc
  }

  public func decodeTimestamp(from jwt: JWT, with key: String) -> Date? {
    guard
      let jwtPayload = JWTDecoder().decodePayload(from: jwt.raw),
      let json = try? JSONSerialization.jsonObject(with: jwtPayload) as? [String: Any],
      let unixTimestamp = json[key] as? Double
    else { return nil }
    return Date(timeIntervalSince1970: unixTimestamp)
  }

  // MARK: Private

  private var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

}

// MARK: Utils

extension SdJWTDecoder {

  private func getJws(from rawCredential: String) throws -> JWS {
    guard
      let rawJwt = rawCredential.separatedByDisclosures.map(String.init).first
    else { throw DecoderError.invalidRawCredential }
    return try .init(compactSerialization: rawJwt)
  }

  private func findSelectiveDisclosures(in jwtPayloadData: Data) throws -> [SdJwtDigest] {
    guard
      let json = try JSONSerialization.jsonObject(with: jwtPayloadData) as? [String: Any],
      let vc = json["vc"] as? [String: Any],
      let credentialSubject = vc["credentialSubject"] as? [String: Any]
    else { throw DecoderError.keyNotFound("credentialSubject") }
    return try recursiveSearch(in: credentialSubject, key: "_sd")
  }

  private func findAlgorithm(in jwtPayloadData: Data, defaultAlgorithm: StringDigest.Algorithm = .sha256) throws -> StringDigest.Algorithm {
    guard
      let json = try JSONSerialization.jsonObject(with: jwtPayloadData) as? [String: Any],
      let stringAlgorithm = json["_sd_alg"] as? String
    else { return defaultAlgorithm }
    return StringDigest.Algorithm(rawValue: stringAlgorithm) ?? defaultAlgorithm
  }

  private func recursiveSearch<T>(in root: [String: Any], key: String) throws -> T {
    if let value = root[key] as? T {
      return value
    }
    for (_, value) in root {
      if let nestedDictionary = value as? [String: Any] {
        return try recursiveSearch(in: nestedDictionary, key: key)
      }
    }
    throw DecoderError.keyNotFound(key)
  }

  private func findDigest(for disclosure: String, in digests: [SdJwtDigest], algorithm: StringDigest.Algorithm) throws -> SdJwtDigest? {
    let actualDigest = try disclosure.digest(algorithm: algorithm)
    guard
      let digest = digests.first(where: { $0 == actualDigest })
    else {
      return nil
    }
    return digest
  }

  private func getByte(at index: Int, in data: Data) throws -> Int {
    guard data.isGzipped else {
      throw DecoderError.invalidStatusList
    }

    let decompressedData = try data.gunzipped()

    let byteIndex = index / 8 // Get the index of the byte

    guard byteIndex < decompressedData.count else {
      throw DecoderError.indexOutOfRange
    }

    let byte = decompressedData[byteIndex]
    let bitIndex = index % 8

    // Get the value of the bit at index
    let bitStatus = byte & (1 << (7 - bitIndex))

    return Int(bitStatus)
  }

}
