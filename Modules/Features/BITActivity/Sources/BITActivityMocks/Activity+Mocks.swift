import Foundation

@testable import BITActivity
@testable import BITTestingCore

extension Activity: Mockable {
  struct Mock {
    static let sampleReceive: Activity = .decode(fromFile: "sample-activity-receive", bundle: .module)
    static let samplePresentation: Activity = .decode(fromFile: "sample-activity-presentation", bundle: .module)
  }
}
