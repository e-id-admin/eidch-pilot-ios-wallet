import BITActivity
import BITCredential
import BITCredentialShared
import BITNetworking
import Factory
import Foundation

// MARK: - DenyPresentationUseCase

public struct DenyPresentationUseCase: DenyPresentationUseCaseProtocol {

  // MARK: Lifecycle

  public init(
    repository: PresentationRepositoryProtocol = Container.shared.presentationRepository(),
    addActivityUseCase: AddActivityToCredentialUseCaseProtocol = Container.shared.addActivityUseCase())
  {
    self.repository = repository
    self.addActivityUseCase = addActivityUseCase
  }

  // MARK: Public

  public func execute(for credential: Credential, requestObject: RequestObject, and presentationMetadata: PresentationMetadata) async throws {
    guard let url = URL(string: requestObject.responseUri) else { throw SubmitPresentationError.wrongSubmissionUrl }
    let presentationRequestBody = PresentationRequestBody(error: .clientRejected)
    try await repository.submitPresentation(from: url, presentationRequestBody: presentationRequestBody)
    try? await addActivityUseCase.execute(type: .presentationDeclined, credential: credential, verifier: ActivityVerifier(presentationMetadata))
  }

  // MARK: Private

  private let repository: PresentationRepositoryProtocol
  private let addActivityUseCase: AddActivityToCredentialUseCaseProtocol

}
