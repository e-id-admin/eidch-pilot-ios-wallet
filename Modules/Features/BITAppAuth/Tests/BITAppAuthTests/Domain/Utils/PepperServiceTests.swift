import Foundation
import XCTest
@testable import BITAppAuth
@testable import BITCrypto
@testable import BITTestingCore

// MARK: - ValidateBiometricUseCaseTests

final class PepperServiceTests: XCTestCase {

  // MARK: Internal

  override func setUp() {
    spyEncrypter = EncryptableSpy()
    spyPepperRepository = PepperRepositoryProtocolSpy()
    pepperService = PepperService(hasher: spyEncrypter, pepperRepository: spyPepperRepository)
  }

  func testGeneratePepper() throws {
    let mockInitialVector: Data = .init()
    let mockAlgorithm: BITCrypto.Algorithm = .sha256
    let mockSecKey: SecKey = SecKeyTestsHelper.createPrivateKey()

    spyEncrypter.generateRandomBytesLengthReturnValue = mockInitialVector
    spyEncrypter.algorithm = mockAlgorithm
    spyPepperRepository.createPepperKeyReturnValue = mockSecKey
    let secKey = try pepperService.generatePepper()
    XCTAssertEqual(mockSecKey, secKey)
    XCTAssertTrue(spyEncrypter.generateRandomBytesLengthCalled)
    XCTAssertTrue(spyPepperRepository.setPepperInitialVectorCalled)
    XCTAssertTrue(spyPepperRepository.createPepperKeyCalled)

    XCTAssertEqual(mockAlgorithm.initialVectorSize, spyEncrypter.generateRandomBytesLengthReceivedLength)
    XCTAssertEqual(mockInitialVector, spyPepperRepository.setPepperInitialVectorReceivedInitialVector)
  }

  // MARK: Private

  // swiftlint:disable all
  private var spyEncrypter: EncryptableSpy!
  private var spyPepperRepository: PepperRepositoryProtocolSpy!
  private var pepperService: PepperServiceProtocol!
  // swiftlint:enable all

}
