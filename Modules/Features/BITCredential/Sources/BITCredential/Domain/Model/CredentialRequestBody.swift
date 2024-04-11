import Foundation

// MARK: - CredentialRequestBody

public struct CredentialRequestBody: Codable {

  var format: String
  let proof: CredentialRequestProof
  let credentialDefinition: CredentialRequestBodyDefinition

  enum CodingKeys: String, CodingKey {
    case format
    case proof
    case credentialDefinition = "credential_definition"
  }
}

// MARK: CredentialRequestBody.Mock

extension CredentialRequestBody {

  func asDictionnary() -> [String: Any] {
    [
      "format": format,
      "proof": [
        "proof_type": proof.proofType,
        "jwt": proof.jwt,
      ],
      "credential_definition": [
        "types": credentialDefinition.types,
      ],
    ]
  }
}

// MARK: - CredentialRequestProof

struct CredentialRequestProof: Codable {
  let jwt: String
  let proofType: String

  enum CodingKeys: String, CodingKey {
    case jwt
    case proofType = "proof_type"
  }
}

// MARK: - CredentialRequestBodyDefinition

struct CredentialRequestBodyDefinition: Codable, Equatable {
  let types: [String]
}
