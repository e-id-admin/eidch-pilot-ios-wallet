import Foundation
@testable import BITSdJWT
@testable import BITTestingCore

extension JWT {

  struct Mock {

    // MARK: Internal

    static let sample: JWT = decodeRawText(fromFile: validFilename)
    static let sampleData: Data = getData(fromFile: validFilename)
    static let validStatusSample: JWT = decodeRawText(fromFile: validStatusFilename)
    static let validStatusSampleData: Data = getData(fromFile: validStatusFilename, bundle: .module)
    static let invalidStatusSample: JWT = decodeRawText(fromFile: invalidStatusFilename)
    static let invalidStatusSampleData: Data = getData(fromFile: invalidStatusFilename)

    // MARK: Private

    private static let validFilename = "jwt-valid"
    private static let validStatusFilename = "jwt-valid-status"
    private static let invalidStatusFilename = "jwt-invalid-status"

    private static func decodeRawText(fromFile filename: String, bundle: Bundle = Bundle.module) -> JWT {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do { return try JWT(
        raw:
        String(contentsOf: fileURL, encoding: .utf8)
          .replacingOccurrences(of: "\n", with: "")
          .replacingOccurrences(of: "\"", with: "")
      ) }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }

    private static func getData(fromFile filename: String, bundle: Bundle = Bundle.module) -> Data {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt")
      else { fatalError("Impossible to read \(filename)") }
      do {
        let text = try String(contentsOf: fileURL, encoding: .utf8).replacingOccurrences(of: "\n", with: "")
        return text.data(using: .utf8) ?? Data()
      } catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }

  }

}
