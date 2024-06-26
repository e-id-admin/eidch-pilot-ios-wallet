import Foundation

public enum CredentialStatus: String, Codable, CaseIterable {
  case valid
  case invalid
  case unknown
}
