# BITVault

Securely store, retrieve, and operate on cryptographic keys in iOS using the Secure Enclave and Keychain.

## Introduction 

The Vault library offers a streamlined and robust interface for dealing with cryptographic keys on iOS devices, leveraging the power of the Secure Enclave and the security of the Keychain.

## Features

- Secure Key Generation: Generate secure cryptographic keys with ease.
- Key Retrieval and Deletion: Efficiently retrieve and manage your keys.
- Encryption and Decryption: Encrypt and decrypt data using keys from the Secure Enclave.
- Signing and Verification: Sign data and verify signatures using your keys.
- Flexible Access Control: Set access controls tailored to your specific needs.

## Requirements

iOS 14.0+
Swift 5.1+

## Usage

```swift
import Vault

let vault = Vault()

// Generate Private Key
let privateKey = try? vault.generatePrivateKey(withIdentifier: "com.example.private")

// Encryption
let originalData = "Hello, Vault!".data(using: .utf8)!
let encryptedData = try? vault.encrypt(data: originalData, withIdentifier: "com.example.private")

// Decryption
let decryptedData = try? vault.decrypt(data: encryptedData!, withIdentifier: "com.example.private")
```

## Access Parameters

Vault provides the ability to set specific access controls on stored keys. By using parameters like kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, developers can specify conditions for key access. For example, with kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, the data in the keychain item can be accessed only when the device has a passcode set and has been unlocked at least once after a restart. Harness these parameters to strike a balance between security and usability, tailoring access to specific needs and ensuring multi-tiered security for sensitive data.