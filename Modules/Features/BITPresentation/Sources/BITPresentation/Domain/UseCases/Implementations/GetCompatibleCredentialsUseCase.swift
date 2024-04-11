import BITCore
import BITCredential
import BITSdJWT
import Factory
import Foundation
import Sextant

// MARK: - CompatibleCredentialsError

public enum CompatibleCredentialsError: Error {
  case noCredentials
  case noCompatibleCredentials
  case notMatchingField
  case invalidCredential
  case jsonPathParsingFailed
  case invalidRequestObject
}

// MARK: - GetCompatibleCredentialsUseCase

struct GetCompatibleCredentialsUseCase: GetCompatibleCredentialsUseCaseProtocol {

  // MARK: Lifecycle

  init(repository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository()) {
    self.repository = repository
  }

  // MARK: Internal

  func execute(requestObject: RequestObject) async throws -> [CompatibleCredential] {
    let requestedFields = try parseRequestedFields(from: requestObject)
    guard requestedFields.isEmpty == false else { throw CompatibleCredentialsError.invalidRequestObject }
    let credentials = try await repository.getAll()
    guard credentials.isEmpty == false else { throw CompatibleCredentialsError.noCredentials }

    var compatibleCredentials: [CompatibleCredential] = []
    for credential in credentials {
      guard let rawCredential = credential.rawCredentials.sdJWT else { continue }

      guard let sdJwt = SdJWT(from: rawCredential.payload) else { throw SdJWTError.notFound }
      let credentialDictionnary = try sdJwt.resolveSelectiveDisclosures()
      var matchingFields: [CodableValue] = []

      do {
        matchingFields = try getMatchingFields(payloadDictionary: credentialDictionnary, requestedFields: requestedFields)
      } catch CompatibleCredentialsError.notMatchingField {
        continue
      } catch {
        throw error
      }

      if matchingFields.count == requestedFields.count {
        compatibleCredentials.append(CompatibleCredential(credential: credential, fields: matchingFields))
      }
    }

    guard compatibleCredentials.isEmpty == false else { throw CompatibleCredentialsError.noCompatibleCredentials }
    return compatibleCredentials
  }

  // MARK: Private

  private let repository: CredentialRepositoryProtocol

}

extension GetCompatibleCredentialsUseCase {

  private struct RequestedField {
    let path: String
    let pattern: String?
    let type: String?

    func matching(valuesIn values: [Any]) throws -> [CodableValue] {
      guard !values.isEmpty else { throw CompatibleCredentialsError.notMatchingField }
      guard let pattern, let type else {
        return values.compactMap { try? CodableValue(anyValue: $0) }
      }

      return values.compactMap {
        let string = String(describing: $0)
        guard let range = string.range(of: pattern, options: .regularExpression) else { return nil }
        return CodableValue(value: String(string[range]), as: type)
      }
    }
  }

  private func parseRequestedFields(from requestObject: RequestObject) throws -> [RequestedField] {
    guard
      requestObject.presentationDefinition.inputDescriptors.isEmpty == false
    else { throw CompatibleCredentialsError.invalidRequestObject }

    return requestObject.presentationDefinition.inputDescriptors.flatMap { descriptor -> [RequestedField] in
      descriptor.constraints.fields.flatMap { field -> [RequestedField] in
        guard let firstPath = field.path.first else { return [] }
        return [RequestedField(path: firstPath, pattern: field.filter?.pattern, type: field.filter?.type)]
      }
    }
  }

  private func getMatchingFields(payloadDictionary: [String: Any], requestedFields: [RequestedField]) throws -> [CodableValue] {
    var matchingFields = [CodableValue]()

    for field in requestedFields {
      guard
        let unwrappedValues = payloadDictionary.query(values: field.path)?.compactMap({ $0 })
      else { throw CompatibleCredentialsError.jsonPathParsingFailed }

      try matchingFields.append(contentsOf: field.matching(valuesIn: unwrappedValues))
    }
    return matchingFields
  }

}
