import Foundation
import Spyable

@Spyable
public protocol PresentationRepositoryProtocol {
  func fetchRequestObject(from url: URL) async throws -> RequestObject
  func submitPresentation(from url: URL, presentationRequestBody: PresentationRequestBody) async throws
}
