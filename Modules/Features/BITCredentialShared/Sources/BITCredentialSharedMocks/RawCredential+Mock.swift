import Foundation

@testable import BITCredentialShared
@testable import BITTestingCore

extension RawCredential: Mockable {

  struct Mock {

    // MARK: Internal

    static var sample: RawCredential = .decode(fromFile: "raw-credential", bundle: Bundle.module)

    static var array: [RawCredential] = [
      .init(payload: .init(), privateKeyIdentifier: .init()),
      .init(payload: .init(), privateKeyIdentifier: .init()),
      .init(payload: .init(), privateKeyIdentifier: .init()),
    ]

    static var sampleWithStatus: RawCredential {
      readFromFile("raw-credential-jwt")
    }

    static var sampleWithStatusExpired: RawCredential {
      readFromFile("raw-credential-jwt-expired")
    }

    // MARK: Private

    private static func readFromFile(_ filename: String) -> RawCredential {
      guard let fileURL = Bundle.module.url(forResource: filename, withExtension: "txt") else { fatalError("Impossible to read \(filename)") }

      do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        guard let data = content.data(using: .utf8) else { fatalError("Impossible to read \(filename)") }
        return .init(payload: data, privateKeyIdentifier: UUID())
      }
      catch { fatalError("Error reading the file: \(error.localizedDescription)") }
    }
  }

}
