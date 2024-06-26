import BITAnalytics
import BITCredentialShared
import Factory
import Foundation

// MARK: - CredentialDetailViewModel

@MainActor
class CredentialDetailViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    _ credential: Credential,
    checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol = Container.shared.checkAndUpdateCredentialStatusUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credential = credential
    self.checkAndUpdateCredentialStatusUseCase = checkAndUpdateCredentialStatusUseCase
    self.analytics = analytics
    credentialBody = CredentialDetailBody(from: credential)
  }

  // MARK: Internal

  enum AnalyticsEvent: AnalyticsEventProtocol {
    case checkStatusFailed
    case cannotLoadPoliceQRCode
  }

  @Published var credentialBody: CredentialDetailBody
  @Published var isPoliceQRCodePresented: Bool = false
  @Published var isDeleteCredentialPresented: Bool = false
  @Published var isActivitiesListPresented: Bool = false

  @Published var credential: Credential {
    didSet {
      credentialBody = CredentialDetailBody(from: credential)
    }
  }

  var qrPoliceQRcode: Data? {
    guard
      let qrImage = credential.claims.first(where: { $0.key == CredentialDetailBody.Constant.policeQRKey })?.value,
      let data = Data(base64URLEncoded: qrImage)
    else {
      analytics.log(AnalyticsEvent.cannotLoadPoliceQRCode)
      return nil
    }

    return data
  }

  func onAppear() async {
    await updateCredentialStatus()
  }

  func refresh() async {
    await updateCredentialStatus()
  }

  // MARK: Private

  private let checkAndUpdateCredentialStatusUseCase: CheckAndUpdateCredentialStatusUseCaseProtocol
  private let analytics: AnalyticsProtocol

  private func updateCredentialStatus() async {
    guard let credential = try? await checkAndUpdateCredentialStatusUseCase.execute(for: credential) else {
      analytics.log(AnalyticsEvent.checkStatusFailed)
      return
    }

    self.credential = credential
  }

}
