import Spyable

@Spyable
public protocol DenyPresentationUseCaseProtocol {
  func execute(requestObject: RequestObject) async throws
}
