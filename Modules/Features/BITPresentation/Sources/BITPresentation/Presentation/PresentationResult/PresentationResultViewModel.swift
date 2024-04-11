import BITCore
import BITCredential
import Combine
import Factory
import Foundation

@MainActor
public class PresentationResultViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    presentationMetadata: PresentationMetadata,
    completed: @escaping () -> Void)
  {
    self.presentationMetadata = presentationMetadata
    self.completed = completed

    date = DateFormatter.presentationResult.string(from: Date())
  }

  // MARK: Internal

  var completed: () -> Void

  let presentationMetadata: PresentationMetadata
  let date: String
}
