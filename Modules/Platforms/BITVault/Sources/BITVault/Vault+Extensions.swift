import Foundation

extension Vault {

  func createAccessControl(accessControlFlags: SecAccessControlCreateFlags, protection: CFString) throws -> SecAccessControl {
    var accessControlError: Unmanaged<CFError>?
    guard
      let accessControl = SecAccessControlCreateWithFlags(
        kCFAllocatorDefault,
        protection,
        accessControlFlags,
        &accessControlError)
    else {
      if let error = accessControlError?.takeRetainedValue() {
        throw VaultError.keyGenerationError(reason: "Access control creation failed with error: \(error)")
      } else {
        throw VaultError.keyGenerationError(reason: "Unknown error during access control creation.")
      }
    }
    return accessControl
  }

}
