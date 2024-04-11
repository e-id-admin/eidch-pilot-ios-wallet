import BITLocalAuthentication
import Factory
import Foundation

public struct HasDevicePinUseCase: HasDevicePinUseCaseProtocol {

  // MARK: Lifecycle

  public init(
    localAuthenticationPolicyValidator: LocalAuthenticationPolicyValidatorProtocol = Container.shared.localAuthenticationPolicyValidator(),
    context: LAContextProtocol = Container.shared.authContext())
  {
    self.localAuthenticationPolicyValidator = localAuthenticationPolicyValidator
    self.context = context
  }

  // MARK: Public

  public func execute() -> Bool {
    (try? localAuthenticationPolicyValidator.validatePolicy(.deviceOwnerAuthentication, context: context)) != nil
  }

  // MARK: Private

  private var context: LAContextProtocol
  private var localAuthenticationPolicyValidator: LocalAuthenticationPolicyValidatorProtocol

}
