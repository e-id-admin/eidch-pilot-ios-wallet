import Foundation

/// `CertificateLoader`: A helper struct for loading security certificates from a specified bundle.
public struct CertificateLoader {

  // MARK: - Public

  /// Loads a certificate from a specified bundle.
  /// - Parameters:
  ///   - name: The name of the certificate file.
  ///   - ext: The extension of the certificate file. Defaults to 'cer'.
  ///   - bundle: The bundle from which to load the certificate.
  /// - Returns: An optional `SecCertificate` object if the certificate is successfully loaded, otherwise `nil`.
  public static func loadCertificate(named name: String, withExtension ext: String = "cer", from bundle: Bundle) -> SecCertificate? {
    guard
      let path = bundle.path(forResource: name, ofType: ext),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData
    else { return nil }
    return SecCertificateCreateWithData(nil, data)
  }
}
