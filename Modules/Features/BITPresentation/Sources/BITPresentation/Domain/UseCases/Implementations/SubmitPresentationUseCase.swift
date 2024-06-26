import BITActivity
import BITCredential
import BITCredentialShared
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
    repository: PresentationRepositoryProtocol = Container.shared.presentationRepository(),
    addActivityUseCase: AddActivityToCredentialUseCaseProtocol = Container.shared.addActivityUseCase())
  {
    self.jwtGenerator = jwtGenerator
    self.repository = repository
    self.addActivityUseCase = addActivityUseCase
  }

  // MARK: Public

  public func execute(requestObject: RequestObject, credential: Credential, presentationMetadata: PresentationMetadata) async throws {
    guard let rawCredential = credential.rawCredentials.sdJWT else {
      throw SubmitPresentationError.credentialInvalid
    }

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
      try? await addActivityUseCase.execute(type: .presentationAccepted, credential: credential, verifier: ActivityVerifier(presentationMetadata))
    } catch {
      guard let err = error as? NetworkError else { throw error }
      switch err.status {
      case .internalServerError,
           .unprocessableEntity:
        throw SubmitPresentationError.presentationFailed
      case .badRequest,
           .invalidGrant:
        try? await addActivityUseCase.execute(type: .presentationAccepted, credential: credential, verifier: ActivityVerifier(presentationMetadata))
        throw SubmitPresentationError.credentialInvalid
      default: throw error
      }
    }
  }

  // MARK: Private

  private let jwtGenerator: PresentationJWTGeneratorProtocol
  private let repository: PresentationRepositoryProtocol
  private let addActivityUseCase: AddActivityToCredentialUseCaseProtocol

}
