import BITCore
import Combine
import Factory
import Foundation

@MainActor
public class PresentationResultViewModel: ObservableObject {

  // MARK: Lifecycle

  public init(
    presentationMetadata: PresentationMetadata,
    date: Date = Date(),
    completed: @escaping () -> Void)
  {
    self.presentationMetadata = presentationMetadata
    self.date = date
    self.completed = completed
  }

  // MARK: Internal

  let completed: () -> Void
  let presentationMetadata: PresentationMetadata

  var formattedDate: String {
    "\(DateFormatter.longDateFormatter.string(from: date)) | \(DateFormatter.shortHourFormatter.string(from: date))"
  }

  // MARK: Private

  private let date: Date
}
