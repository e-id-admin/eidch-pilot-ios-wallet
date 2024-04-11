import BITCore
import Foundation

// MARK: - PresentationRequestBody

public struct PresentationRequestBody: Codable {

  var vpToken: String?
  var presentationSubmission: PresentationSubmission?
  var error: ErrorType?
  var errorDescription: String?

  func asDictionnary() -> [String: Any] {
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase

      var dictionary: [String: Any?] = [:]
      dictionary["vp_token"] = vpToken
      dictionary["error"] = error?.rawValue
      dictionary["error_description"] = errorDescription

      if let presentationSubmission {
        guard let presentationSubmissionString = try String(data: encoder.encode(presentationSubmission), encoding: .utf8) else { return dictionary.compactMapValues { $0 } }
        dictionary["presentation_submission"] = presentationSubmissionString
      }

      return dictionary.compactMapValues { $0 }
    } catch {
      return [:]
    }
  }

}

extension PresentationRequestBody {

  enum ErrorType: String, Codable {
    case clientRejected = "client_rejected"
  }

  struct PathNested: Codable {
    let path: String
    let format: String
  }

  struct PresentationSubmission: Codable {
    let id: String
    let definitionId: String
    let descriptorMap: [DescriptorMap]
  }

  struct DescriptorMap: Codable {
    let id: String
    let format: String
    let path: String
    let pathNested: PathNested
  }
}
