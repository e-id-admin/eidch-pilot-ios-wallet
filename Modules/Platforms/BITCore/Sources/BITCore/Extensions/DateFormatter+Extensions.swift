import Foundation

extension DateFormatter {

  // MARK: Lifecycle

  public convenience init(format: String) {
    self.init()
    dateFormat = format
  }

  // MARK: Public

  public static let presentationResult: DateFormatter = .init(format: "dd MMMM yyyy | HH:mm")
  public static let chShortFormat: DateFormatter = .init(format: "dd.MM.yyyy")

}
