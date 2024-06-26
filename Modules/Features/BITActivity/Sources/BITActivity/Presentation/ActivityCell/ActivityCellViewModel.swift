import BITTheming
import Foundation

class ActivityCellViewModel {

  // MARK: Lifecycle

  init(_ activity: Activity) {
    self.activity = activity
  }

  // MARK: Internal

  let activity: Activity

  var verifierName: String {
    activity.verifier?.name ?? activity.credential.preferredIssuerDisplay?.name ?? L10n.globalNotAssigned
  }

  var description: String {
    activity.type.description
  }

  var formattedDate: String {
    "\(DateFormatter.longDateFormatter.string(from: activity.createdAt)) | \(DateFormatter.shortHourFormatter.string(from: activity.createdAt))"
  }

  var type: ActivityType {
    activity.type
  }
}
