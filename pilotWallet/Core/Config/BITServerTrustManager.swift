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
    let secCertificates = evaluator.certificate.compactMap { certificateName in
      CertificateLoader.loadDERCertificate(named: certificateName.rawValue, from: .main)
    }
    return (evaluator.domain.rawValue, PinnedCertificatesTrustEvaluator(certificates: secCertificates))
  }
}

// MARK: BITServerTrustManager.TrustEvaluator

extension BITServerTrustManager {
  fileprivate enum TrustEvaluator: CaseIterable {
    case admin

    // MARK: Internal

    var domain: Domain {
      switch self {
      case .admin: Domain.astraAdminCh
      }
    }

    var certificate: [Certificate] {
      switch self {
      case .admin: Certificate.allCases
      }
    }
  }

  fileprivate enum Domain: String, CaseIterable {
    case astraAdminCh = "*.astra.admin.ch"
  }

  fileprivate enum Certificate: String, CaseIterable {
    case quoVadisRootCA2G3 = "QuoVadisRootCA2G3"
    case digiCertGlobalRootG2 = "DigiCertGlobalRootG2"
  }
}
