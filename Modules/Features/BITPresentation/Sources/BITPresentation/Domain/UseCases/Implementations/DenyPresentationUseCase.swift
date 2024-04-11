import BITNetworking
import Factory
import Foundation

// MARK: - DenyPresentationUseCase

public struct DenyPresentationUseCase: DenyPresentationUseCaseProtocol {

  // MARK: Lifecycle

  public init(repository: PresentationRepositoryProtocol = Container.shared.presentationRepository()) {
    self.repository = repository
  }

  // MARK: Public

  public func execute(requestObject: RequestObject) async throws {
    guard let url = URL(string: requestObject.responseUri) else { throw SubmitPresentationError.wrongSubmissionUrl }
    let presentationRequestBody = PresentationRequestBody(error: .clientRejected)
    try await repository.submitPresentation(from: url, presentationRequestBody: presentationRequestBody)
  }

  // MARK: Private

  private let repository: PresentationRepositoryProtocol

}
