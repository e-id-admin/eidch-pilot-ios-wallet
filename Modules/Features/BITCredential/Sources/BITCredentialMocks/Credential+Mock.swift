import Foundation
@testable import BITCredential
@testable import BITTestingCore

// MARK: Mockable

extension Credential: Mockable {

  struct Mock {

    struct File {
      static let sample = "credential-coredata-sample"
      static let diploma = "credential-coredata-diploma"
      static let withoutRawCredential = "credential-coredata-without-raw-credential"
      static let displaysAdditional = "credential-coredata-locale-additional"
      static let displaysAppDefault = "credential-coredata-locale-app-default"
      static let displaysFallback = "credential-coredata-locale-fallback"
      static let displaysUnsupported = "credential-coredata-locale-unsupported"
      static let displaysEmpty = "credential-coredata-locale-empty"
    }

    static let array: [Credential] = [sample, diploma, sampleWithoutRawCredential]
    static let arrayMultipass: [Credential] = [sample, sample, sample, sample]

    static let sample: Credential = .decode(fromFile: Self.File.sample, bundle: .module)
    static let diploma: Credential = .decode(fromFile: Self.File.diploma, bundle: .module)
    static let sampleWithoutRawCredential: Credential = .decode(fromFile: File.withoutRawCredential, bundle: .module)
    static let sampleDisplaysAdditional: Credential = .decode(fromFile: File.displaysAdditional, bundle: .module)
    static let sampleDisplaysAppDefault: Credential = .decode(fromFile: File.displaysAppDefault, bundle: .module)
    static let sampleDisplaysFallback: Credential = .decode(fromFile: File.displaysFallback, bundle: .module)
    static let sampleDisplaysUnsupported: Credential = .decode(fromFile: File.displaysUnsupported, bundle: .module)
    static let sampleDisplaysEmpty: Credential = .decode(fromFile: File.displaysEmpty, bundle: .module)

  }

}
