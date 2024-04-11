import Factory
import SwiftUI

// MARK: - CredentialDeleteViewModel

public class CredentialDeleteViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    credential: Credential,
    deleteCredentialUseCase: DeleteCredentialUseCaseProtocol = Container.shared.deleteCredentialUseCase())
  {
    self.credential = credential
    self.deleteCredentialUseCase = deleteCredentialUseCase
  }

  // MARK: Public

  public func confirm() async throws {
    try await deleteCredentialUseCase.execute(credential)
  }

  // MARK: Internal

  var credential: Credential

  // MARK: Private

  private var deleteCredentialUseCase: DeleteCredentialUseCaseProtocol

}
