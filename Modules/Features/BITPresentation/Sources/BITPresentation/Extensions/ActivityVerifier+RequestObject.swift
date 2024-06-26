import BITActivity
import Foundation

extension ActivityVerifier {

  public init(_ presentationMetadata: PresentationMetadata) {
    var verifierBase64Logo: Data?
    let verifierName = presentationMetadata.verifier?.clientName ?? L10n.globalNotAssigned

    if let logoUrl = presentationMetadata.verifier?.logoUri {
      verifierBase64Logo = try? Data(contentsOf: logoUrl)
    }

    let activityVerifierId = UUID()

    let claims: [ActivityVerifierCredentialClaim] = presentationMetadata.attributes.compactMap({
      .init(presentationMetadataField: $0, activityVerifierId: activityVerifierId, claimId: UUID())
    })

    self.init(id: activityVerifierId, name: verifierName, credentialClaims: claims, logo: verifierBase64Logo)
  }
}

extension ActivityVerifierCredentialClaim {

  init?(presentationMetadataField: PresentationMetadata.Field, activityVerifierId: UUID, claimId: UUID) {
    self.init(
      id: claimId,
      key: presentationMetadataField.key,
      value: presentationMetadataField.value,
      valueType: presentationMetadataField.type.rawValue,
      order: presentationMetadataField.order,
      activityVerifierId: activityVerifierId,
      displays: presentationMetadataField.displays.map { .init(name: $0.name, locale: $0.locale ?? .defaultLocaleIdentifier, activityClaimId: claimId) })
  }
}
