import BITCredentialShared
import BITSdJWT
import Foundation
import Spyable

// MARK: - SaveCredentialUseCaseProtocol

@Spyable
public protocol SaveCredentialUseCaseProtocol {
  func execute(sdJWT: SdJWT, metadataWrapper: CredentialMetadataWrapper) async throws -> Credential
}
