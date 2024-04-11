import Factory
import Foundation

public struct HasDeletedCredentialUseCase: HasDeletedCredentialUseCaseProtocol {
  public init(hasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol = Container.shared.hasDeletedCredentialRepository()) {
    self.hasDeletedCredentialRepository = hasDeletedCredentialRepository
  }

  public func execute() -> Bool {
    hasDeletedCredentialRepository.hasDeletedCredential()
  }

  private let hasDeletedCredentialRepository: HasDeletedCredentialRepositoryProtocol
}
