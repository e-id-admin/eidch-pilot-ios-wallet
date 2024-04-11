import BITNetworking
import Factory
import Foundation
import Moya

struct PresentationRepository: PresentationRepositoryProtocol {
  private let networkService: NetworkService = NetworkContainer.shared.service()

  func fetchRequestObject(from url: URL) async throws -> RequestObject {
    try await networkService.request(PresentationEndpoint.requestObject(url: url))
  }

  func submitPresentation(from url: URL, presentationRequestBody: PresentationRequestBody) async throws {
    try await networkService.request(PresentationEndpoint.submission(url: url, presentationBody: presentationRequestBody))
  }
}
