import BITCredential
import BITNetworking
import Factory
import Foundation

// MARK: - SubmitPresentationError

enum SubmitPresentationError: Error {
  case wrongSubmissionUrl
  case presentationFailed
  case credentialInvalid
}

// MARK: - SubmitPresentationUseCase

public struct SubmitPresentationUseCase: SubmitPresentationUseCaseProtocol {

  // MARK: Lifecycle

  public init(
    jwtGenerator: PresentationJWTGeneratorProtocol = Container.shared.presentationJWTGenerator(),
    repository: PresentationRepositoryProtocol = Container.shared.presentationRepository())
  {
    self.jwtGenerator = jwtGenerator
    self.repository = repository
  }

  // MARK: Public

  public func execute(requestObject: RequestObject, rawCredential: RawCredential, presentationMetadata: PresentationMetadata) async throws {
    let vpToken = try jwtGenerator.generate(requestObject: requestObject, rawCredential: rawCredential, presentationMetadata: presentationMetadata)

    let descriptorMap: [PresentationRequestBody.DescriptorMap] = requestObject.presentationDefinition.inputDescriptors
      .map({
        .init(id: $0.id, format: "jwt_vp_json", path: "$", pathNested: .init(path: "$.vp.verifiableCredential[0]", format: $0.format.jwtVc.title))
      })

    let presentationSubmission = PresentationRequestBody.PresentationSubmission(
      id: UUID().uuidString,
      definitionId: requestObject.presentationDefinition.id,
      descriptorMap: descriptorMap)

    let submitPresentationBody = PresentationRequestBody(vpToken: vpToken.raw, presentationSubmission: presentationSubmission)

    guard let submissionURL = URL(string: requestObject.responseUri) else {
      throw SubmitPresentationError.wrongSubmissionUrl
    }

    do {
      try await repository.submitPresentation(from: submissionURL, presentationRequestBody: submitPresentationBody)
    } catch NetworkError.unprocessableEntity, NetworkError.internalServerError {
      throw SubmitPresentationError.presentationFailed
    } catch NetworkError.badRequest, NetworkError.invalidGrant {
      throw SubmitPresentationError.credentialInvalid
    } catch {
      throw error
    }
  }

  // MARK: Private

  private let jwtGenerator: PresentationJWTGeneratorProtocol
  private let repository: PresentationRepositoryProtocol

}
