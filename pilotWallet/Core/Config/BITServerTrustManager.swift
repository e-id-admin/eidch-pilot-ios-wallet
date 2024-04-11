import Alamofire
import BITNetworking
import Foundation

// MARK: - BITServerTrustManager

/// `BITServerTrustManager`: A subclass of `WildcardServerTrustManager` provided by BITNetworking.
/// Designed for handling server trust and configure certificate pinning for the BIT application based on domain name patterns.
class BITServerTrustManager: WildcardServerTrustManager {

  // MARK: Lifecycle

  init() {
    let evaluators = TrustEvaluator.allCases.compactMap { Self.createEvaluator($0) }
    super.init(evaluators: Dictionary(uniqueKeysWithValues: evaluators))
  }

  // MARK: Private

  private static func createEvaluator(_ evaluator: TrustEvaluator) -> (String, ServerTrustEvaluating)? {
    guard let certificate = CertificateLoader.loadCertificate(named: evaluator.certificate, withExtension: evaluator.certificateExtension, from: .main) else {
      return nil
    }
    return (evaluator.domain, PinnedCertificatesTrustEvaluator(certificates: [certificate]))
  }
}

// MARK: BITServerTrustManager.TrustEvaluator

extension BITServerTrustManager {
  fileprivate enum TrustEvaluator: CaseIterable {
    case admin

    // MARK: Internal

    var domain: String {
      switch self {
      case .admin: "*.astra.admin.ch"
      }
    }

    var certificate: String {
      switch self {
      case .admin: "QuoVadisRootCA2G3"
      }
    }

    var certificateExtension: String {
      "der"
    }
  }
}
