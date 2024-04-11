import Foundation
@testable import BITCredential
@testable import BITTestingCore

// MARK: - FetchCredentialResponse + Mockable

extension FetchCredentialResponse: Mockable {

  struct Mock {
    static var sample = FetchCredentialResponse(rawCredential: Self.readFromFile("raw-credential-jwt"), format: "jwt_vc")
    static var sampleExpired = FetchCredentialResponse(rawCredential: Self.readFromFile("raw-credential-jwt-expired"), format: "jwt_vc")
    static var sampleWithInvalidDisclosures = FetchCredentialResponse(rawCredential: Self.readFromFile("raw-credential-jwt-invalid-disclosures"), format: "jwt_vc")

    private static func readFromFile(_ filename: String) -> String {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt") else { fatalError("Impossible to read \(filename)") }

      do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        return content
      }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }
  }

}
