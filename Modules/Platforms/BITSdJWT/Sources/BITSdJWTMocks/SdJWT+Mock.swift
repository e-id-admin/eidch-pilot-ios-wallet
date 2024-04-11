import Foundation
@testable import BITSdJWT
@testable import BITTestingCore

extension SdJWT: Mockable {

  struct Mock {

    // MARK: Internal

    static let sample: SdJWT = .decode(fromFile: sampleFilename, bundle: Bundle.module)
    static let sampleData: Data = SdJWT.getData(fromFile: sampleFilename, bundle: Bundle.module) ?? Data()

    static let sampleDiploma: SdJWT = .decode(fromFile: sampleDiplomaFilename, bundle: Bundle.module)
    static let sampleDiplomaData: Data = SdJWT.getData(fromFile: sampleDiplomaFilename, bundle: Bundle.module) ?? Data()

    static let sampleId: SdJWT = .decode(fromFile: sampleIdFilename, bundle: Bundle.module)
    static let sampleIdData: Data = SdJWT.getData(fromFile: sampleIdFilename, bundle: Bundle.module) ?? Data()

    static let sampleNoName: SdJWT = .decode(fromFile: sampleNoMandatoryNameFilename, bundle: Bundle.module)
    static let sampleExpired: SdJWT = .decode(fromFile: sampleExpiredFilename, bundle: Bundle.module)
    static let sampleClaimInvalid: SdJWT? = decodeRawText(fromFile: sampleClaimInvalidFilename)

    static let sampleNoDisclosures: Data = SdJWT.getData(fromFile: sampleNoDisclosuresFilename, bundle: Bundle.module) ?? Data()
    static let sampleOneClaimStringData: Data = SdJWT.getData(fromFile: sampleOneClaimStringFilename, bundle: Bundle.module) ?? Data()
    static let sampleOneClaimIntData: Data = SdJWT.getData(fromFile: sampleOneClaimIntFilename, bundle: Bundle.module) ?? Data()
    static let sampleOneClaimDoubleData: Data = SdJWT.getData(fromFile: sampleOneClaimDoubleFilename, bundle: Bundle.module) ?? Data()
    static let sampleOneClaimBoolData: Data = SdJWT.getData(fromFile: sampleOneClaimBoolFilename, bundle: Bundle.module) ?? Data()
    static let sampleOneClaimDictionaryData: Data = SdJWT.getData(fromFile: sampleOneClaimDictionaryFilename, bundle: Bundle.module) ?? Data()
    static let sampleOneClaimArrayData: Data = SdJWT.getData(fromFile: sampleOneClaimArrayFilename, bundle: Bundle.module) ?? Data()

    // MARK: Private

    private static let sampleFilename = "sd-jwt-sample"
    private static let sampleDiplomaFilename = "sd-jwt-diploma"
    private static let sampleIdFilename = "sd-jwt-id"
    private static let sampleNoMandatoryNameFilename = "sd-jwt-sample-no-mandatory-name"
    private static let sampleExpiredFilename = "sd-jwt-sample-expired"
    private static let sampleNoDisclosuresFilename = "sd-jwt-no-disclosures"
    private static let sampleClaimInvalidFilename = "sd-jwt-claim-invalid"
    private static let sampleOneClaimStringFilename = "sd-jwt-claim-string"
    private static let sampleOneClaimIntFilename = "sd-jwt-claim-int"
    private static let sampleOneClaimDoubleFilename = "sd-jwt-claim-double"
    private static let sampleOneClaimBoolFilename = "sd-jwt-claim-bool"
    private static let sampleOneClaimDictionaryFilename = "sd-jwt-claim-dictionary"
    private static let sampleOneClaimArrayFilename = "sd-jwt-claim-array"

    private static func decodeRawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> SdJWT? {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do { return try SdJWT(from: String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")) }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }

  }

}
