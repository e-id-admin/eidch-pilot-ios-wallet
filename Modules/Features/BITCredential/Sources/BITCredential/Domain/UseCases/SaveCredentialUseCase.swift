import BITSdJWT
import Factory
import Foundation
import Sextant
import Spyable

// MARK: - SaveCredentialUseCase

struct SaveCredentialUseCase: SaveCredentialUseCaseProtocol {

  let credentialRepository: CredentialRepositoryProtocol = Container.shared.databaseCredentialRepository()

  func execute(sdJWT: SdJWT, metadataWrapper: CredentialMetadataWrapper) async throws -> Credential {
    guard let sdJWTRawData = sdJWT.raw.data(using: .utf8) else { throw SaveCredentialError.rawSdJWTNotFound }
    let rawCredential = RawCredential(payload: sdJWTRawData, privateKeyIdentifier: metadataWrapper.privateKeyIdentifier)

    var credential = try Credential(from: rawCredential, metadataWrapper: metadataWrapper)
    credential.displays = credential.displays.compactMap { display in
      parseSummary(from: display, and: rawCredential)
    }

    return try await credentialRepository.create(credential: credential)
  }

}

extension SaveCredentialUseCase {

  private func parseSummary(from credentialDisplay: CredentialDisplay, and rawCredential: RawCredential) -> CredentialDisplay {
    var credentialDisplayCopy = credentialDisplay

    do {
      guard let sdJWT = SdJWT(from: rawCredential.payload) else { throw SdJWTError.notFound }
      let credentialDictionnary = try sdJWT.resolveSelectiveDisclosures()

      guard let jsonPath = credentialDisplay.summary, let userName: String = credentialDictionnary.query(jsonPath) else {
        return credentialDisplay
      }

      credentialDisplayCopy.summary = userName
      return credentialDisplayCopy
    } catch {
      return credentialDisplay
    }
  }
}

// MARK: - SaveCredentialError

enum SaveCredentialError: Error {
  case rawSdJWTNotFound
}
