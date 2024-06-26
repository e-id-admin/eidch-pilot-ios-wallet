import Foundation

@testable import BITCredentialShared
@testable import BITCredentialSharedMocks
@testable import BITPresentation
@testable import BITTestingCore

// MARK: - RequestObject.Mock

extension RequestObject {
  struct Mock {
    private static let sampleFileName = "request-object-multipass"
    static let sample: RequestObject = Mocker.decode(fromFile: Self.sampleFileName, bundle: Bundle.module)
    static let sampleData: Data = Mocker.getData(fromFile: Self.sampleFileName, bundle: Bundle.module) ?? Data()
    static let sampleWithoutClientMetadataData: Data = Mocker.getData(fromFile: "request-object-multipass-no-metadata", bundle: Bundle.module) ?? Data()

    static let sampleMultipassExtraField: RequestObject = Mocker.decode(fromFile: "request-object-multipass-plus-extra-field", bundle: Bundle.module)
    static let sampleWithoutFields: RequestObject = Mocker.decode(fromFile: "request-object-without-fields", bundle: Bundle.module)
    static let sampleDiploma: RequestObject = Mocker.decode(fromFile: "request-object-diploma", bundle: Bundle.module)
  }
}

// MARK: - PresentationMetadata.Mock

extension PresentationMetadata {
  struct Mock {
    static func sample() -> PresentationMetadata {
      let requestObject: RequestObject = Mocker.decode(fromData: RequestObject.Mock.sampleData)
      return PresentationMetadata(attributes: PresentationMetadata.Field.Mock.array, verifier: requestObject.clientMetadata)
    }
  }
}

// MARK: - PresentationMetadata.Field.Mock

extension PresentationMetadata.Field {
  struct Mock {
    static let array: [PresentationMetadata.Field] = [
      PresentationMetadata.Field(key: "firstName", value: "value", type: .string, displayName: "Firstname", order: 2, displays: [
        .init(.init(locale: "fr-CH", name: "Prenom"), claimId: UUID()),
        .init(.init(locale: "de-CH", name: "Vorname"), claimId: UUID()),
      ]),
      PresentationMetadata.Field(key: "lastName", value: "value", type: .string, displayName: "Lastname", order: 1, displays: [
        .init(.init(locale: "fr-CH", name: "Nom"), claimId: UUID()),
        .init(.init(locale: "de-CH", name: "Nachname"), claimId: UUID()),
      ]),
      PresentationMetadata.Field(key: "dateOfBirth", value: "value", type: .string, displayName: "Date of birth", order: 3, displays: [
        .init(.init(locale: "fr-CH", name: "Date de naissance"), claimId: UUID()),
        .init(.init(locale: "de-CH", name: "Geburstag"), claimId: UUID()),
      ]),
    ]
  }
}

// MARK: - PresentationRequestBody + Mockable

extension PresentationRequestBody: Mockable {

  struct Mock {
    static let sampleData: Data = PresentationRequestBody.getData(fromFile: "presentation-request-body", bundle: Bundle.module) ?? Data()
    static func sample() -> PresentationRequestBody {
      Mocker.decode(fromData: sampleData)
    }
  }

}

// MARK: - CompatibleCredential.Mock

extension CompatibleCredential {
  struct Mock {
    static let array: [CompatibleCredential] = [BIT, diploma]
    static let BIT: CompatibleCredential = .init(credential: .Mock.sample, fields: [.init(value: "firstName", as: "string"), .init(value: "lastName", as: "string")])
    static let diploma: CompatibleCredential = .init(credential: .Mock.diploma, fields: [.init(value: "firstName", as: "string"), .init(value: "lastName", as: "string")])
  }
}
