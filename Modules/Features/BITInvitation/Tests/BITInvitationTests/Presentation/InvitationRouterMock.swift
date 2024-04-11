import BITCredential
import BITInvitation
import Foundation

class InvitationRouterMock: InvitationRouter.Routes {

  var didCallClose = false
  var didCallCloseOnComplete = false
  var didCallPop = false
  var didCallPopToRoot = false
  var didCallCredentialOffer = false
  var didCallDismiss = false
  var didCallDeeplink = false

  func credentialOffer(credential: Credential) {
    didCallCredentialOffer = true
  }

  func close() {
    didCallClose = true
  }

  func close(onComplete: (() -> Void)?) {
    didCallCloseOnComplete = true
  }

  func dismiss() {
    didCallDismiss = true
  }

  func pop() {
    didCallPop = true
  }

  func popToRoot() {
    didCallPopToRoot = true
  }

  func deeplink(url: URL, animated: Bool) {
    didCallDeeplink = true
  }

}
