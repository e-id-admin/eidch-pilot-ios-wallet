import BITCore
import Combine
import Factory
import Foundation
import SwiftUI

// MARK: - CredentialOfferViewModel

@MainActor
public class CredentialOfferViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    credential: Credential,
    routes: CredentialOfferRouter.Routes? = nil,
    isPresented: Binding<Bool> = .constant(true))
  {
    self.credential = credential
    credentialBody = CredentialDetailBody(from: credential)
    _isPresented = isPresented
    self.routes = routes
  }

  // MARK: Public

  @Binding public var isPresented: Bool
  @Published public var isConfirmationScreenPresented: Bool = false

  // MARK: Internal

  @Published var credential: Credential
  @Published var credentialBody: CredentialDetailBody

  func accept() {
    isPresented = false
    routes?.dismiss()
  }

  func refuse() {
    isConfirmationScreenPresented = true
  }

  func backHome() {
    isPresented = false
    routes?.dismiss()
  }

  // MARK: Private

  private let routes: CredentialOfferRouter.Routes?

}
