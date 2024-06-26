import BITActivity
import BITAnalytics
import Factory
import Foundation
import SwiftUI

// MARK: - ActivityDetailViewModel

class ActivityDetailViewModel: ObservableObject {

  // MARK: Lifecycle

  init(
    _ activity: Activity,
    isPresented: Binding<Bool> = .constant(true),
    deleteActityUseCase: DeleteActivityUseCaseProtocol = Container.shared.deleteActivityUseCase(),
    analytics: AnalyticsProtocol = Container.shared.analytics())
  {
    _isPresented = isPresented
    self.activity = activity
    self.deleteActityUseCase = deleteActityUseCase
    self.analytics = analytics
  }

  // MARK: Internal

  var activity: Activity
  @Binding var isPresented: Bool

  var verifierLogo: Data? {
    activity.verifier?.logo
  }

  var verifierName: String? {
    activity.verifier?.name
  }

  func deleteActivity() async {
    do {
      try await deleteActityUseCase.execute(activity)
      isPresented = false
    } catch {
      analytics.log(AnalyticsErrorEvent.deleteActivityError(error))
    }
  }

  // MARK: Private

  private let deleteActityUseCase: DeleteActivityUseCaseProtocol
  private let analytics: AnalyticsProtocol
}

// MARK: ActivityDetailViewModel.AnalyticsErrorEvent

extension ActivityDetailViewModel {

  enum AnalyticsErrorEvent: AnalyticsErrorEventProtocol {
    case deleteActivityError(_ error: Error)

    // MARK: Internal

    func error() -> any Error {
      switch self {
      case .deleteActivityError(let error):
        error
      }
    }

    func name(_ provider: any AnalyticsProviderProtocol.Type) -> String {
      switch self {
      case .deleteActivityError:
        "deleteActivityError"
      }
    }

    func parameters(_ provider: any AnalyticsProviderProtocol.Type) -> Parameters {
      switch self {
      case .deleteActivityError(let error):
        ["errorDescription": error.localizedDescription]
      }
    }
  }

}
