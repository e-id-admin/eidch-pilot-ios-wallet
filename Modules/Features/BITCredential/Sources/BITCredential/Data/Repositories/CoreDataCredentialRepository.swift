import BITCore
import BITDataStore
import BITSdJWT
import Factory
import Foundation

// MARK: - CoreDataCredentialRepositoryError

enum CoreDataCredentialRepositoryError: Error {
  case notFound
}

// MARK: - CoreDataCredentialRepository

struct CoreDataCredentialRepository: CredentialRepositoryProtocol {

  // MARK: Public

  public func create(credential: Credential) async throws -> Credential {
    try await database.managedContext.perform {
      let credentialEntity = CredentialEntity(context: database.managedContext, credential: credential)
      try database.managedContext.save()
      return Credential(credentialEntity)
    }
  }

  public func get(id: UUID) async throws -> Credential {
    let entity = try await getEntity(id)
    return Credential(entity)
  }

  @discardableResult
  public func update(_ credential: Credential) async throws -> Credential {
    let entity = try await getEntity(credential.id)
    return try await database.managedContext.perform {
      entity.setValues(from: credential)
      try database.managedContext.save()
      return credential
    }
  }

  public func delete(_ id: UUID) async throws {
    let entity = try await getEntity(id)
    return try await database.managedContext.perform {
      database.managedContext.delete(entity)
      try database.managedContext.save()
    }
  }

  public func getAll() async throws -> [Credential] {
    try await database.managedContext.perform {
      let request = CredentialEntity.fetchRequest()
      let results = try database.managedContext.fetch(request)
      return results.map { .init($0) }
    }
  }

  // MARK: Internal

  func fetchCredential(from url: URL, credentialRequestBody: CredentialRequestBody, acccessToken: AccessToken) async throws -> FetchCredentialResponse { fatalError("Not usable in that context.") }
  func fetchIssuerPublicKeyInfo(from jwksUrl: URL) async throws -> IssuerPublicKeyInfo { fatalError("Not usable in that context.") }
  func fetchAccessToken(from url: URL, preAuthorizedCode: String) async throws -> AccessToken { fatalError("Not usable in that context.") }
  func fetchOpenIdConfiguration(from issuerURL: URL) async throws -> OpenIdConfiguration { fatalError("Not usable in that context.") }
  func fetchMetadata(from issuerUrl: URL) async throws -> CredentialMetadata { fatalError("Not usable in that context.") }
  func fetchCredentialStatus(from url: URL) async throws -> JWT { fatalError("Not usable in that context.") }

  // MARK: Private

  private let database: CoreDataStoreProtocol = Container.shared.dataStore()

  private func getEntity(_ id: UUID) async throws -> CredentialEntity {
    try await database.managedContext.perform {
      let request = CredentialEntity.fetchRequest(byId: id)
      let results = try database.managedContext.fetch(request)
      guard let entity = results.first else { throw CoreDataCredentialRepositoryError.notFound }
      return entity
    }
  }
}
