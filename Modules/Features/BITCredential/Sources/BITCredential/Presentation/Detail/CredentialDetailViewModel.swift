import Factory
import Foundation

@MainActor
class CredentialDetailViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    _ credential: Credential,
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase())
  {
    self.credential = credential
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    credentialBody = CredentialDetailBody(from: credential)
  }

  // MARK: Internal

  @Published var credentialBody: CredentialDetailBody
  @Published var isPoliceQRCodePresented: Bool = false
  @Published var isDeleteCredentialPresented: Bool = false

  @Published var credential: Credential {
    didSet {
      credentialBody = CredentialDetailBody(from: credential)
    }
  }

  var qrPoliceQRcode: Data? {
    guard
      let qrImage = credential.claims.first(where: { $0.key == CredentialDetailBody.Constant.policeQRKey })?.value,
      let data = Data(base64URLEncoded: qrImage)
    else { return nil }

    return data
  }

  func onAppear() async {
    await updateCredentialStatus()
  }

  // MARK: Private

  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol

  private func updateCredentialStatus() async {
    guard let credential = try? await checkAndUpdateCredentialStatusUseCase.execute(for: credential) else {
      return
    }

    self.credential = credential
  }

}
