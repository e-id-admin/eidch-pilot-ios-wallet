import BITCore
import BITNetworking
import BITSdJWT
import BITVault
import Factory
import Foundation
import SwiftUI

@MainActor
extension Container {

  // MARK: Public

  public var credentialOfferViewModel: ParameterFactory<(credential: Credential, routes: CredentialOfferRouter.Routes?, isPresented: Binding<Bool>), CredentialOfferViewModel> {
    self { CredentialOfferViewModel(credential: $0, routes: $1, isPresented: $2) }
  }

  public var credentialOfferModule: ParameterFactory<Credential, CredentialOfferModule> {
    self { CredentialOfferModule(credential: $0) }
  }

  // MARK: Internal

  var credentialOfferDeclineConfirmationViewModel: ParameterFactory<(Credential, Binding<Bool>, () -> Void), CredentialOfferDeclineConfirmationViewModel> {
    self { CredentialOfferDeclineConfirmationViewModel(credential: $0, isPresented: $1, onDelete: $2) }
  }

  var credentialOfferHeaderViewModel: ParameterFactory<CredentialIssuerDisplay, CredentialOfferHeaderViewModel> {
    self { CredentialOfferHeaderViewModel($0) }
  }

  var credentialDetailsCardViewModel: ParameterFactory<Credential, CredentialDetailsCardViewModel> {
    self { CredentialDetailsCardViewModel(credential: $0) }
  }

  var credentialDetailViewModel: ParameterFactory<Credential, CredentialDetailViewModel> {
    self { CredentialDetailViewModel($0) }
  }

}

extension Container {

  // MARK: Public

  public var credentialOfferRouter: Factory<CredentialOfferRouter> {
    self { CredentialOfferRouter() }
  }

  public var fetchMetadataUseCase: Factory<FetchMetadataUseCaseProtocol> {
    self { FetchMetadataUseCase() }
  }

  public var fetchCredentialUseCase: Factory<FetchCredentialUseCaseProtocol> {
    self { FetchCredentialUseCase() }
  }

  public var saveCredentialUseCase: Factory<SaveCredentialUseCaseProtocol> {
    self { SaveCredentialUseCase() }
  }

  public var getCredentialListUseCase: Factory<GetCredentialListUseCaseProtocol> {
    self { GetCredentialListUseCase() }
  }

  public var checkAndUpdateCredentialStatusUseCase: Factory<CheckAndUpdateCredentialStatusUseCaseProtocol> {
    self { CheckAndUpdateCredentialStatusUseCase() }
  }

  public var vaultOptions: Factory<VaultOption> {
    self { [.secureEnclavePermanently] }
  }

  public var vaultAccessControlFlags: Factory<SecAccessControlCreateFlags> {
    self { [.privateKeyUsage, .applicationPassword] }
  }

  public var vaultProtection: Factory<CFString> {
    self { kSecAttrAccessibleWhenUnlockedThisDeviceOnly }
  }

  public var databaseCredentialRepository: Factory<CredentialRepositoryProtocol> {
    self { CoreDataCredentialRepository() }
  }

  public var deleteCredentialUseCase: Factory<DeleteCredentialUseCaseProtocol> {
    self { DeleteCredentialUseCase() }
  }

  public var hasDeletedCredentialRepository: Factory<HasDeletedCredentialRepositoryProtocol> {
    self { UserDefaultHasDeletedCredentialRepository() }
  }

  public var hasDeletedCredentialUseCase: Factory<HasDeletedCredentialUseCaseProtocol> {
    self { HasDeletedCredentialUseCase() }
  }

  // MARK: Internal

  var sdJwtDecoder: Factory<SdJWTDecoderProtocol> {
    self { SdJWTDecoder() }
  }

  var preferredUserLocales: Factory <[UserLocale]> {
    self { Locale.preferredLanguages }
  }

  var preferredUserLanguageCodes: Factory<[UserLanguageCode]> {
    self {
      self.preferredUserLocales().compactMap({
        guard let sequence = $0.split(separator: "-").first else { return nil }
        return String(sequence)
      })
    }
  }

  var dateBuffer: Factory<TimeInterval> {
    self { 15 }
  }

  var jwtManager: Factory<JWTManageable> {
    self { JWTManager() }
  }

  var credentialJWTGenerator: Factory<CredentialJWTGeneratorProtocol> {
    self { CredentialJWTGenerator() }
  }

  var credentialDidJWKGenerator: Factory<CredentialDidJWKGeneratorProtocol> {
    self { CredentialDidJWKGenerator() }
  }

  var credentialPrivateKeyGenerator: Factory<CredentialPrivateKeyGeneratorProtocol> {
    self { CredentialPrivateKeyGenerator() }
  }

  var credentialJWTValidator: Factory<CredentialJWTValidatorProtocol> {
    self { CredentialJWTValidator() }
  }

  var vault: Factory<VaultProtocol> {
    self { Vault() }
  }

  var apiCredentialRepository: Factory<CredentialRepositoryProtocol> {
    self { ApiCredentialRepository() }
  }

  // MARK: - Status check validators

  var statusValidators: Factory<[any StatusCheckValidatorProtocol]> {
    self {
      [
        self.validFromValidator(),
        self.validUntilValidator(),
        self.revocationValidator(),
      ]
    }
  }

  var validFromValidator: Factory<StatusCheckValidatorProtocol> { self { ValidFromValidator() } }
  var validUntilValidator: Factory<StatusCheckValidatorProtocol> { self { ValidUntilValidator() } }
  var revocationValidator: Factory<StatusCheckValidatorProtocol> { self { RevocationValidator() } }
}
