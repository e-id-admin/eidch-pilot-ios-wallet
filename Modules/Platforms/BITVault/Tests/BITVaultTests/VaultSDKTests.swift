//import XCTest
//@testable import VaultSDK
//
//class VaultTests: XCTestCase {
//
//  var vault: Vault!
//
//  override func setUp() {
//    super.setUp()
//    vault = Vault(algorithm: .eciesEncryptionStandardVariableIVX963SHA256AESGCM, accessFlags: [.privateKeyUsage])
//  }
//
//  override func tearDown() {
//    vault = nil
//    super.tearDown()
//  }
//
//  func testPrivateKeyGeneration() {
//    XCTAssertNoThrow(try vault.generatePrivateKey(withIdentifier: "testPrivateKeyGeneration"))
//  }
//
//  func testGetPrivateKey() {
//    let identifier = "testGetPrivateKey"
//    do {
//      _ = try vault.generatePrivateKey(withIdentifier: identifier, [.privateKeyUsage, .userPresence], options: [.savePermanently])
//      let key = try vault.getPrivateKey(withIdentifier: identifier)
//      XCTAssertNotNil(key)
//    } catch {
//      XCTFail("Failed to get private key with error: \(error)")
//    }
//  }
//
//  func testGetPublicKey() {
//    let identifier = "testGetPublicKey"
//    do {
//      let privateKey = try vault.generatePrivateKey(withIdentifier: identifier)
//      let publicKey = try vault.getPublicKey(for: privateKey)
//      XCTAssertNotNil(publicKey)
//    } catch {
//      XCTFail("Failed to get public key with error: \(error)")
//    }
//  }
//
//  func testEncryptDecryptWithKey() {
//    let identifier = "testEncryptDecryptWithKey"
//    let testData = "Hello World".data(using: .utf8)!
//
//    do {
//      let privateKey = try vault.generatePrivateKey(withIdentifier: identifier)
//      let encryptedData = try vault.encrypt(data: testData, usingKey: privateKey)
//      let decryptedData = try vault.decrypt(data: encryptedData, usingKey: privateKey)
//
//      XCTAssertEqual(testData, decryptedData)
//    } catch {
//      XCTFail("Encryption/Decryption failed with error: \(error)")
//    }
//  }
//
//  func testEncryptDecryptWithIdentifier() {
//    let identifier = "testEncryptDecryptWithIdentifier"
//    let testData = "Hello World".data(using: .utf8)!
//
//    do {
//      _ = try vault.generatePrivateKey(withIdentifier: identifier)
//      let encryptedData = try vault.encrypt(data: testData, withIdentifier: identifier)
//      let decryptedData = try vault.decrypt(data: encryptedData, withIdentifier: identifier)
//
//      XCTAssertEqual(testData, decryptedData)
//    } catch {
//      XCTFail("Encryption/Decryption with identifier failed with error: \(error)")
//    }
//  }
//
//  func testDeletePrivateKey() {
//    let identifier = "testDeletePrivateKey"
//    do {
//      _ = try vault.generatePrivateKey(withIdentifier: identifier)
//      XCTAssertNoThrow(try vault.deletePrivateKey(withIdentifier: identifier))
//    } catch {
//      XCTFail("Failed to delete private key with error: \(error)")
//    }
//  }
//
//  func testSigningAndVerificationWithKey() {
//    let identifier = "testSigningAndVerificationWithKey"
//    let testData = "Test Message".data(using: .utf8)!
//
//    do {
//      let privateKey = try vault.generatePrivateKey(withIdentifier: identifier)
//      let publicKey = try vault.getPublicKey(for: privateKey)
//
//      let signature = try vault.sign(data: testData, usingKey: privateKey)
//
//      let isVerified = try vault.verify(signature: signature, for: testData, usingKey: publicKey)
//
//      XCTAssertTrue(isVerified, "Verification of the signature failed.")
//    } catch {
//      XCTFail("Signing/Verification failed with error: \(error)")
//    }
//  }
//
//  func testSigningAndVerificationWithIdentifier() {
//    let identifier = "testSigningAndVerificationWithIdentifier"
//    let testData = "Test Message".data(using: .utf8)!
//
//    do {
//      _ = try vault.generatePrivateKey(withIdentifier: identifier)
//
//      let signature = try vault.sign(data: testData, withIdentifier: identifier)
//
//      let isVerified = try vault.verify(signature: signature, for: testData, withIdentifier: identifier)
//
//      XCTAssertTrue(isVerified, "Verification with identifier of the signature failed.")
//    } catch {
//      XCTFail("Signing/Verification with identifier failed with error: \(error)")
//    }
//  }
//
//  func testRetrieveNonexistentKey() {
//    XCTAssertThrowsError(try vault.getPrivateKey(withIdentifier: "nonexistentIdentifier"), "Expected an error when retrieving a key that doesn't exist") { error in
//      XCTAssertTrue(error is VaultError, "Expected a VaultError")
//    }
//  }
//
//  func testInvalidKeyIdentifier() {
//    XCTAssertThrowsError(try vault.generatePrivateKey(withIdentifier: ""), "Expected an error when using an empty identifier") { error in
//      XCTAssertTrue(error is VaultError, "Expected a VaultError")
//    }
//
//    let longIdentifier = String(repeating: "a", count: 1000) // A very long identifier
//    XCTAssertThrowsError(try vault.generatePrivateKey(withIdentifier: longIdentifier), "Expected an error when using a very long identifier") { error in
//      XCTAssertTrue(error is VaultError, "Expected a VaultError")
//    }
//  }
//
//  func testDuplicateKey() {
//    XCTAssertNoThrow(try vault.generatePrivateKey(withIdentifier: "testIdentifier"), "Expected no error when generating a key for the first time")
//    XCTAssertThrowsError(try vault.generatePrivateKey(withIdentifier: "testIdentifier"), "Expected an error when trying to save a key with an existing identifier") { error in
//      XCTAssertTrue(error is VaultError, "Expected a VaultError")
//    }
//  }
//
//  func testInvalidAccessFlags() {
//    let invalidVault = Vault(accessFlags: [])
//    XCTAssertThrowsError(try invalidVault.generatePrivateKey(withIdentifier: "testIdentifier"), "Expected an error when using invalid access flags") { error in
//      XCTAssertTrue(error is VaultError, "Expected a VaultError")
//    }
//  }
//
//}
