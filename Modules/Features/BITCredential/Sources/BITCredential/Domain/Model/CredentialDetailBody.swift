import BITCore
import BITSdJWT
import Foundation

// MARK: - CredentialDetailBody

public struct CredentialDetailBody: Equatable {

  // MARK: Lifecycle

  public init(display: Self.Display, claims: [Self.Claim], status: CredentialStatus) {
    self.display = display
    self.claims = claims
    self.status = status
  }

  public init(from originalCredential: Credential) {
    var credential = originalCredential

    if originalCredential.isELFA {
      credential.claims.removeAll(where: { $0.key == Constant.policeQRKey })
    }

    var claims: [Self.Claim] = []
    for claim in credential.claims {
      let displayName = claim.preferredDisplay?.name ?? claim.key
      let valueType = ValueType(rawValue: claim.valueType)

      claims.append(Claim(id: claim.id, key: displayName, value: claim.value, type: valueType))
    }

    let issuerDisplayName = credential.preferredDisplay?.name ?? L10n.globalNotAssigned
    self.init(display: Display(id: credential.id, name: issuerDisplayName), claims: claims, status: credential.status)
  }

  // MARK: Public

  public var display: Self.Display
  public var claims: [Self.Claim]
  public var status: CredentialStatus

  // MARK: Internal

  enum Constant {
    static let policeQRKey = "policeQRImage"
    static let ELFAKey = "ELFA"
  }

}

// MARK: CredentialDetailBody.Claim

extension CredentialDetailBody {
  public struct Claim: Identifiable, Equatable {
    public var id: UUID
    var key: String
    var value: String
    var type: ValueType?
  }
}

extension CredentialDetailBody.Claim {

  var imageData: Data? {
    guard let type else {
      return nil
    }

    return type.isImage ? Data(base64URLEncoded: value) : nil
  }
}

// MARK: - CredentialDetailBody.Display

extension CredentialDetailBody {
  public struct Display: Equatable {
    public var id: UUID
    public var name: String
  }
}

extension Credential {
  fileprivate var isELFA: Bool {
    guard
      let payload = rawCredentials.sdJWTPayload,
      let sdJwt = SdJWT(from: payload),
      let type = sdJwt.verifiableCredential?.type
    else { return false }
    return type.contains(where: {
      $0.compare(CredentialDetailBody.Constant.ELFAKey, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    })
  }
}
