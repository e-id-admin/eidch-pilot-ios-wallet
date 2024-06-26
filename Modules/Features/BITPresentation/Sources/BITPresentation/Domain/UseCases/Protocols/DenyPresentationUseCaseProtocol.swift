import BITCredentialShared
import Spyable

@Spyable
public protocol DenyPresentationUseCaseProtocol {
  func execute(for credential: Credential, requestObject: RequestObject, and presentationMetadata: PresentationMetadata) async throws
}
