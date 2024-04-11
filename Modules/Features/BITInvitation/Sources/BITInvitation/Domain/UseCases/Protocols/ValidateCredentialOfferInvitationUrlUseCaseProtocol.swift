import BITCore
import BITCredential
import Foundation
import Spyable

@Spyable
public protocol ValidateCredentialOfferInvitationUrlUseCaseProtocol {
  func execute(_ url: URL) throws -> CredentialOffer
}
