import BITAnalytics
import BITCredentialShared
import Factory
import SwiftUI

// MARK: - CredentialDeleteViewModel

public class CredentialDeleteViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    credential: Credential,
    isPresented: Binding<Bool> = .constant(true),
    isHomePresented: Binding<Bool> = .constant(true),
    deleteCredentialUseCase: DeleteCredentialUseCaseProtocol = Container.shared.deleteCredentialUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    self.credential = credential
    self.deleteCredentialUseCase = deleteCredentialUseCase
    self.analytics = analytics

    _isPresented = isPresented
    _isHomePresented = isHomePresented
  }

  // MARK: Public

  public func confirm() async throws {
    do {
      try await deleteCredentialUseCase.execute(credential)
      close()
    } catch {
      analytics.log(AnalyticsErrorEvent.deleteCredentialError(error))
    }
  }

  // MARK: Internal

  @Binding var isPresented: Bool
  @Binding var isHomePresented: Bool

  var credential: Credential

  func cancel() {
    isPresented = false
  }

  func close() {
    isHomePresented = false
  }

  // MARK: Private

  private var deleteCredentialUseCase: DeleteCredentialUseCaseProtocol
  private let analytics: AnalyticsProtocol

}

// MARK: CredentialDeleteViewModel.AnalyticsErrorEvent

extension CredentialDeleteViewModel {

  enum AnalyticsErrorEvent: AnalyticsErrorEventProtocol {
    case deleteCredentialError(_ error: Error)

    // MARK: Internal

    func error() -> any Error {
      switch self {
      case .deleteCredentialError(let error):
        error
      }
    }

    func name(_ provider: any AnalyticsProviderProtocol.Type) -> String {
      switch self {
      case .deleteCredentialError:
        "deleteCredentialError"
      }
    }

    func parameters(_ provider: any AnalyticsProviderProtocol.Type) -> Parameters {
      switch self {
      case .deleteCredentialError(let error):
        ["errorDescription": error.localizedDescription]
      }
    }
  }

}
