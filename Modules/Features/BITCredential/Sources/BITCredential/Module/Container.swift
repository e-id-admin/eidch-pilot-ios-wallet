import BITActivity
import BITCredentialShared
import BITSdJWT
import BITVault
import Factory
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

  var credentialActivitiesViewModel: ParameterFactory<(Credential, Binding<Bool>), CredentialActivitiesViewModel> {
    self { CredentialActivitiesViewModel(credential: $0, isPresented: $1) }
  }

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

  var activityDetailViewModel: ParameterFactory<(Activity, Binding<Bool>), ActivityDetailViewModel> {
    self { ActivityDetailViewModel($0, isPresented: $1) }
  }

  var credentialDeleteViewModel: ParameterFactory<(Credential, Binding<Bool>, Binding<Bool>), CredentialDeleteViewModel> {
    self { CredentialDeleteViewModel(credential: $0, isPresented: $1, isHomePresented: $2) }
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

  public var addActivityUseCase: Factory<AddActivityToCredentialUseCaseProtocol> {
    self { AddActivityToCredentialUseCase() }
  }

  public var getLastCredentialActivitiesUseCase: Factory<GetLastCredentialActivitiesUseCaseProtocol> {
    self { GetLastCredentialActivitiesUseCase() }
  }

  public var credentialDetailNumberOfActivitiesElements: Factory<Int> {
    self { 3 }
  }

  public var getLastActivityUseCase: Factory<GetLastActivityUseCaseProtocol> {
    self { GetLastActivityUseCase() }
  }

  // MARK: Internal

  var getGroupedCredentialActivitiesUseCase: Factory<GetGroupedCredentialActivitiesUseCaseProtocol> {
    self { GetGroupedCredentialActivitiesUseCase() }
  }

  var sdJwtDecoder: Factory<SdJWTDecoderProtocol> {
    self { SdJWTDecoder() }
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

  var credentialKeyPairGenerator: Factory<CredentialKeyPairGeneratorProtocol> {
    self { CredentialPrivateKeyGenerator() }
  }

  var credentialJWTValidator: Factory<CredentialJWTValidatorProtocol> {
    self { CredentialJWTValidator() }
  }

  var keyManager: Factory<KeyManagerProtocol> {
    self { KeyManager() }
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

  var credentialActivityRepository: Factory<CredentialActivityRepositoryProtocol> {
    self { CoreDataCredentialRepository() }
  }

}
