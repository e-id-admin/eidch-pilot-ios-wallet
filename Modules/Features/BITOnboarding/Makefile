.DEFAULT_GOAL := generate

SWIFTGEN := swiftgen
SWIFTFORMAT := swiftformat

swiftgen:
	@echo "=> Generating Swift code using swiftgen"
	$(SWIFTGEN)

swiftformat:
	@echo "=> Formatting Swift code using swiftformat"
	$(SWIFTFORMAT) .

open: swiftgen swiftformat
	@echo "=> Opening SPM"
	open "Package.swift"

generate: swiftgen swiftformat
