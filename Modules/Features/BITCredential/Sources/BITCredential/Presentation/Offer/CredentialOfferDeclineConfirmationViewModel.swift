import Factory
import SwiftUI

@MainActor
public class CredentialOfferDeclineConfirmationViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    credential: Credential,
    isPresented: Binding<Bool> = .constant(true),
    onDelete: @escaping () -> Void,
    deleteCredentialUseCase: DeleteCredentialUseCaseProtocol = Container.shared.deleteCredentialUseCase())
  {
    self.credential = credential
    _isPresented = isPresented
    self.deleteCredentialUseCase = deleteCredentialUseCase
    self.onDelete = onDelete
  }

  // MARK: Public

  @Binding public var isPresented: Bool

  // MARK: Internal

  @Published var isLoading = false

  let credential: Credential
  let onDelete: () -> Void

  func cancel() {
    isPresented = false
  }

  func delete() async {
    isLoading = true
    try? await deleteCredentialUseCase.execute(credential)
    isLoading = false
    onDelete()
    isPresented = false
  }

  // MARK: Private

  private let deleteCredentialUseCase: DeleteCredentialUseCaseProtocol

}
