import BITCrypto
import Factory
import Foundation

struct PepperService: PepperServiceProtocol {

  // MARK: Lifecycle

  public init(
    hasher: Encryptable = Container.shared.hasher(),
    pepperRepository: PepperRepositoryProtocol = Container.shared.pepperRepository())
  {
    self.hasher = hasher
    self.pepperRepository = pepperRepository
  }

  // MARK: Internal

  func generatePepper() throws -> SecKey {
    try generateInitialVector()
    return try pepperRepository.createPepperKey()
  }

  // MARK: Private

  private let hasher: Encryptable
  private let pepperRepository: PepperRepositoryProtocol

  private func generateInitialVector() throws {
    let initialVector = try hasher.generateRandomBytes(length: hasher.algorithm.initialVectorSize)
    try pepperRepository.setPepperInitialVector(initialVector)
  }

}
