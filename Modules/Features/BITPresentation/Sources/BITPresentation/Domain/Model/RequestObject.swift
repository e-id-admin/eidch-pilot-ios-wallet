import BITCore
import Foundation

// MARK: - RequestObject

public struct RequestObject: Codable, Equatable {
  let presentationDefinition: PresentationDefinition
  let nonce: String
  let responseUri: String
  let clientMetadata: ClientMetadata?

  enum CodingKeys: String, CodingKey {
    case presentationDefinition = "presentation_definition"
    case nonce
    case responseUri = "response_uri"
    case clientMetadata = "client_metadata"
  }
}

// MARK: - ClientMetadata

public struct ClientMetadata: Codable, Equatable {
  let clientName: String?
  let logoUri: URL?

  enum CodingKeys: String, CodingKey {
    case clientName = "client_name"
    case logoUri = "logo_uri"
  }
}

// MARK: - PresentationDefinition

struct PresentationDefinition: Codable, Equatable {
  let id: String
  let inputDescriptors: [InputDescriptor]

  enum CodingKeys: String, CodingKey {
    case id
    case inputDescriptors = "input_descriptors"
  }
}

// MARK: - InputDescriptor

struct InputDescriptor: Codable, Equatable {
  let id: String
  let format: Format
  let constraints: Constraints
}

// MARK: - Constraints

struct Constraints: Codable, Equatable {
  let fields: [Field]
}

// MARK: - Field

struct Field: Codable, Equatable {
  let path: [String]
  let filter: Filter?
}

// MARK: - Filter

struct Filter: Codable, Equatable {
  let type, pattern: String
}

// MARK: - Format

struct Format: Codable, Equatable {
  let jwtVc: JwtVc

  enum CodingKeys: String, CodingKey {
    case jwtVc = "jwt_vc"
  }
}

// MARK: - JwtVc

struct JwtVc: Codable, Equatable {
  let alg: String
  var title: String {
    "jwt_vc"
  }
}
