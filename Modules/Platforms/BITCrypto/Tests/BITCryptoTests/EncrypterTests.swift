import XCTest
@testable import BITCrypto

final class EncrypterTests: XCTestCase {

  // MARK: Internal

  func testGenerateRandomBytes_sha256() throws {
    try assertGenerateSalt(for: .sha256)
  }

  func testGenerateRandomBytes_sha512() throws {
    try assertGenerateSalt(for: .sha512)
  }

  func testHash256() throws {
    let input = try "123456".asData()
    let expected = "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92"
    let encrypter: Encrypter = .init(algorithm: .sha256)
    let result = try encrypter.hash(data: input)
    XCTAssertNotNil(result)
    XCTAssertEqual(expected, result.hexString)
  }

  func testHash512() throws {
    let input = try "123456".asData()
    let expected = "ba3253876aed6bc22d4a6ff53d8406c6ad864195ed144ab5c87621b6c233b548baeae6956df346ec8c17f5ea10f35ee3cbc514797ed7ddd3145464e2a0bab413"
    let encrypter: Encrypter = .init(algorithm: .sha512)
    let result = try encrypter.hash(data: input)
    XCTAssertNotNil(result)
    XCTAssertEqual(expected, result.hexString)
  }

  func testHash256_salted() throws {
    let input = try "123456".asData()
    let salt = try "46084f444652c40282fc8de1ae0868f4".asData()
    let expected = "6c77d95036a0b78066ef7b392c65ae1fc9e4af60baa8983869c02912395a0e0d"
    let encrypter: Encrypter = .init(algorithm: .sha256)
    let result = try encrypter.hash(data: input, withSalt: salt)
    XCTAssertNotNil(result)
    XCTAssertEqual(expected, result.hexString)
  }

  func testHash512_salted() throws {
    let input = try "123456".asData()
    let salt = try "46084f444652c40282fc8de1ae0868f4".asData()
    let expected = "e9f9cf01d10cf34b1b1cf71053a9badf5d463f32e29d267e48bbef377233fd8767bb2e53af5ab7d2999830b45c08a92cda5e596eadfc1a39d30e57542d45e971"
    let encrypter: Encrypter = .init(algorithm: .sha512)
    let result = try encrypter.hash(data: input, withSalt: salt)
    XCTAssertNotNil(result)
    XCTAssertEqual(expected, result.hexString)
  }

  // MARK: Private

  private func assertGenerateSalt(for algorithm: Algorithm) throws {
    let encrypter = Encrypter(algorithm: algorithm)
    let length = 32
    let salt = try encrypter.generateRandomBytes(length: length).hexString
    XCTAssertTrue(salt.count >= 2 * length) // 2 chars is 1 byte
  }

}
