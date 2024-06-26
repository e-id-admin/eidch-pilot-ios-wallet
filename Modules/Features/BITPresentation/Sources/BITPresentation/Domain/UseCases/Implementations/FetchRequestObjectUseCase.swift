import BITNetworking
import Factory
import Foundation

// MARK: - FetchRequestObjectError

public enum FetchRequestObjectError: Error {
  case invalidPresentationInvitation
}

// MARK: - FetchRequestObjectUseCase

public struct FetchRequestObjectUseCase: FetchRequestObjectUseCaseProtocol {

  // MARK: Lifecycle

  public init(repository: PresentationRepositoryProtocol = Container.shared.presentationRepository()) {
    self.repository = repository
  }

  // MARK: Public

  public func execute(_ url: URL) async throws -> RequestObject {
    do {
      return try await repository.fetchRequestObject(from: url)
    } catch is DecodingError {
      throw FetchRequestObjectError.invalidPresentationInvitation
    } catch {
      guard let err = error as? NetworkError else { throw error }
      if err.status == .hostnameNotFound {
        throw FetchRequestObjectError.invalidPresentationInvitation
      }
      throw error
    }
  }

  // MARK: Private

  private let repository: PresentationRepositoryProtocol

}
