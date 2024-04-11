import BITSdJWT
import Foundation
import Spyable

@Spyable
protocol CredentialJWTValidatorProtocol {
  func validate(_ credentialResponse: FetchCredentialResponse, withPublicKeyInfo publicKeyInfo: IssuerPublicKeyInfo, selectedCredential: CredentialMetadata.CredentialsSupported?) async throws -> SdJWT
}
