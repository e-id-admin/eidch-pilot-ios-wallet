import Foundation
@testable import BITCredentialMocks
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
      return PresentationMetadata(attributes: Field.Mock.array, verifier: requestObject.clientMetadata)
    }
  }
}

// MARK: - PresentationMetadata.Field.Mock

extension PresentationMetadata.Field {
  struct Mock {
    static let array: [PresentationMetadata.Field] = [
      PresentationMetadata.Field(key: "firstName", value: "value", type: .string, displayName: "Firstname"),
      PresentationMetadata.Field(key: "lastName", value: "value", type: .string, displayName: "Lastname"),
      PresentationMetadata.Field(key: "dateOfBirth", value: "value", type: .string, displayName: "Date of birth"),
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
