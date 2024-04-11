import Alamofire
import Foundation

// MARK: - WildcardServerTrustManager

/// A custom `ServerTrustManager` that supports wildcard domain matching.
open class WildcardServerTrustManager: ServerTrustManager {

  // MARK: Public

  /// Returns a `ServerTrustEvaluating` object for a given host.
  /// - Parameter host: The host for which to return the evaluator.
  /// - Throws: An error if no evaluator is found for the host or its root domain.
  /// - Returns: A `ServerTrustEvaluating` object if found.
  public override func serverTrustEvaluator(forHost host: String) throws -> ServerTrustEvaluating? {
    if let exactEvaluation = evaluators[host] {
      return exactEvaluation
    }

    let rootDomain = try getWildcardRootDomain(from: host)
    guard let subdomainEvaluation = evaluators[rootDomain] else {
      throw AFError.serverTrustEvaluationFailed(reason: .noRequiredEvaluator(host: rootDomain))
    }
    return subdomainEvaluation
  }

  // MARK: Private

  /// Retrieves the wildcard root domain from a given host.
  /// - Parameter host: The host from which to extract the root domain.
  /// - Throws: An error if the host is invalid or too short.
  /// - Returns: A wildcard root domain string.
  private func getWildcardRootDomain(from host: String) throws -> String {
    let keys = evaluators.keys.map { String($0) }
    guard let matchingPattern = Self.getMatchingPattern(url: host, patterns: keys) else {
      throw AFError.serverTrustEvaluationFailed(reason: .noRequiredEvaluator(host: host))
    }
    return matchingPattern
  }

}

extension WildcardServerTrustManager {
  private static func getMatchingPattern(url: String, patterns: [String]) -> String? {
    for pattern in patterns {
      let regexPattern = pattern
        .replacingOccurrences(of: ".", with: "\\.")
        .replacingOccurrences(of: "*", with: ".*")

      if let regex = try? NSRegularExpression(pattern: regexPattern, options: []) {
        let range = NSRange(location: 0, length: url.utf16.count)
        if regex.firstMatch(in: url, options: [], range: range) != nil {
          return pattern
        }
      }
    }
    return nil
  }
}
