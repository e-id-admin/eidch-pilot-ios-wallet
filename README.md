# pilotWallet - iOS

<div align="left">
<img src="./Resources/pilotWalletLogo.png?raw=true" width="200" />
</div>

An official Swiss Government project made by the [Federal Office of Information Technology, Systems and Telecommunication FOITT](https://www.bit.admin.ch/)
as part of the electronic identity (E-ID) project.

<div align="left">
<a href='https://apps.apple.com/app/id6478277720' target='_blank'>
<img alt='Download on the App Store' src='./Resources/downloadOnAppStoreLogo.png?raw=true' width="200" />
</a>
</div>

## Table of Contents

- [Overview](#overview)
- [Repositories](#repositories)
- [Installation and Building](#installation-and-building)
- [Contribution Guide](#contribution-guide)
- [License](#license)


## Overview

The pilotWallet app is part of the ecosystem developed for the future official Swiss E-ID.<br/>
The main objective of this early stage development release is to get user and community feedback as early as possible.<br/>

For more information about the project please visit the [infopage](https://github.com/e-id-admin/eidch-pilot-elfa-base-infrastructure?tab=readme-ov-file#project-context).

### Specifications

Following specifications were used for the implementation:

- [OpenID for Verifiable Credential Issuance - draft 12](https://openid.net/specs/openid-4-verifiable-credential-issuance-1_0-12.html)
- [OpenID for Verifiable Presentations - draft 20](https://openid.net/specs/openid-4-verifiable-presentations-1_0-20.html)
- [Verifiable Credentials Data Model v2.0](https://www.w3.org/TR/vc-data-model-2.0/)
- [Presentation Exchange 2.0.0](https://identity.foundation/presentation-exchange/spec/v2.0.0/)

> [!NOTE]
> Please be aware that only parts of these specifications were implemented in this early phase.


## Repositories

* Android App: [pilot-android-wallet](https://github.com/e-id-admin/eidch-pilot-android-wallet)
* iOS App: [pilot-ios-wallet](https://github.com/e-id-admin/eidch-pilot-ios-wallet)
* Issuer, Verifier & Base registry: [pilot-elfa-base-infrastructure](https://github.com/e-id-admin/eidch-pilot-elfa-base-infrastructure)


## Installation and Building

The app requires at least iOS 15.<br/>
The app has been build with Xcode 15.3.

In your terminal, after having cloned the current repository, run the following command:

```bash
make setup
```

The `make` command will set everything up and provide you with an up and running project.

Once in Xcode:
- Select the `pilotWallet Dev` scheme
- Be aware that it's more appropriate to run on real devices rather than in Simulator because of several restrictions and KeyChain usage
- Finally, just build & run in Xcode with `command + R`


## Contribution Guide

We welcome any feedback on the code regarding both the implementation and security aspects. Please follow the guidelines for contributing found in [CONTRIBUTING.md](./CONTRIBUTING.md).

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file for details.
