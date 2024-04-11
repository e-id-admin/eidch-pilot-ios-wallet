import BITCredential
import Spyable

@Spyable
public protocol SubmitPresentationUseCaseProtocol {
  func execute(requestObject: RequestObject, rawCredential: RawCredential, presentationMetadata: PresentationMetadata) async throws
}
