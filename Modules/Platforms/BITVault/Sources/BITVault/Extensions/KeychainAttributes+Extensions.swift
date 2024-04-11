import BITLocalAuthentication
import Foundation

extension [String: Any] {
  mutating func setContext(_ context: LAContextProtocol?, reason: String? = nil) {
    if var context {
      self[kSecUseAuthenticationContext as String] = context
      if let reason {
        context.localizedReason = reason
      }
    }
  }
}
