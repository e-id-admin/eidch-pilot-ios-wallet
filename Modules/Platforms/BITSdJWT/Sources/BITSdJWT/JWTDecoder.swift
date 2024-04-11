import Foundation
import JOSESwift

// MARK: - JWTDecoder

public class JWTDecoder {

  public enum DecoderError: Error {
    case algorithmNotFound
  }

  public func decodeAlgorithmHeader(from rawCredential: String) -> String? {
    do {
      let jws = try decodeJWS(from: rawCredential)
      guard let signatureAlgorithm = jws.header.algorithm else {
        throw DecoderError.algorithmNotFound
      }
      return signatureAlgorithm.rawValue
    } catch {
      return nil
    }
  }

  public func decodePayload(from rawCredential: String) -> Data? {
    do {
      let jws = try decodeJWS(from: rawCredential)
      return jws.payload.data()
    } catch {
      return nil
    }
  }

}

extension JWTDecoder {

  private func decodeJWS(from rawCredential: String) throws -> JWS {
    let jwt = rawCredential.separatedByDisclosures.first.map(String.init) ?? rawCredential
    return try JWS(compactSerialization: jwt)
  }

}
