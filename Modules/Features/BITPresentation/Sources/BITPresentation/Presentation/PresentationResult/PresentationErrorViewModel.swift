import Foundation

public class PresentationErrorViewModel {

  // MARK: Lifecycle

  public init(date: Date = Date()) {
    self.date = date
  }

  // MARK: Internal

  var formattedDate: String {
    "\(DateFormatter.longDateFormatter.string(from: date)) | \(DateFormatter.shortHourFormatter.string(from: date))"
  }

  // MARK: Private

  private let date: Date

}
