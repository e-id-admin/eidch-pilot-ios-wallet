import BITCredentialShared
import Spyable

@Spyable
public protocol SubmitPresentationUseCaseProtocol {
  func execute(requestObject: RequestObject, credential: Credential, presentationMetadata: PresentationMetadata) async throws
}
