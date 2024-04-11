.DEFAULT_GOAL := generate

# Paths
XCODEGEN := xcodegen
SWIFTGEN := swiftgen
SWIFTFORMAT := swiftformat
PROJECT := pilotWallet.xcodeproj

# SPM
SPM_DIRS := Modules/Platforms/BITCore \
			Modules/Platforms/BITNavigation \
			Modules/Platforms/BITTheming \
			Modules/Platforms/BITCrypto \
			Modules/Platforms/BITQRScanner \
			Modules/Platforms/BITNetworking \
			Modules/Platforms/BITVault \
			Modules/Platforms/BITDataStore \
			Modules/Platforms/BITDeeplink \
			Modules/Platforms/BITSdJWT \
			Modules/Platforms/BITLocalAuthentication \
			Modules/Features/BITInvitation \
			Modules/Features/BITOnboarding \
			Modules/Features/BITAppAuth \
			Modules/Features/BITCredential \
			Modules/Features/BITSettings \
			Modules/Features/BITPresentation \
			Modules/Features/BITHome

install:
	@echo "=> Installing tools"
	brew update
	brew bundle
	bundle install

generate-info-plist:
	@echo "=> Generating Info.plist using xcodegen"
	$(XCODEGEN) generate

generate-swiftgen:
	@echo "=> Generating Swift code using swiftgen"
	$(SWIFTGEN) && \
		$(XCODEGEN) generate

prepare-modules:
	@echo "=> Generation & Configuration of Modules"
	for dir in $(SPM_DIRS); do \
		(cd "$$dir" && make); \
	done

swiftformat:
	@echo "=> Formatting Swift code using swiftformat"
	$(SWIFTFORMAT) .

open-project:
	@echo "=> Opening Xcode project"
	open "$(PROJECT)"

generate: generate-info-plist generate-swiftgen swiftformat prepare-modules open-project

setup: install generate swiftformat open-project
	@echo "=> Done"
