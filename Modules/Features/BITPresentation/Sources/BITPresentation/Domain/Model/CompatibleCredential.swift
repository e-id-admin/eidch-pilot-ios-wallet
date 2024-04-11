import BITCore
import BITCredential
import Foundation

// MARK: - CompatibleCredential

public struct CompatibleCredential: Identifiable {
  public let id: UUID = .init()

  let credential: Credential
  let fields: [CodableValue]
}

// MARK: Equatable

extension CompatibleCredential: Equatable {}
