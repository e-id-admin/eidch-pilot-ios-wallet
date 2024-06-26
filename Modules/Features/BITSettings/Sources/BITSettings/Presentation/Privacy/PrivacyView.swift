import BITAppAuth
import BITTheming
import Factory
import SwiftUI

// MARK: - PrivacyView

public struct PrivacyView: View {

  // MARK: Lifecycle

  public init() {
    _viewModel = StateObject(wrappedValue: Container.shared.privacyViewModel())
  }

  // MARK: Public

  public var body: some View {
    ZStack {
      content()
        .font(.custom.body)
        .navigationTitle(L10n.securitySettingsTitle)
    }
  }

  // MARK: Internal

  @StateObject var viewModel: PrivacyViewModel

  // MARK: Private

  @ViewBuilder
  private func content() -> some View {
    ScrollView {
      VStack(spacing: .x10) {
        MenuSection({
          MenuCell(text: L10n.securitySettingsChangePin, disclosureIndicator: .navigation) {
            viewModel.presentPinChangeFlow()
          }

          ToggleMenuCell(text: L10n.securitySettingsBiometrics, isOn: $viewModel.isBiometricEnabled) {
            viewModel.presentBiometricChangeFlow()
          }
          .hasDivider(false)
          .onAppear {
            viewModel.fetchBiometricStatus()
          }
        }, header: {
          MenuHeader(image: "hand.raised", text: L10n.securitySettingsLoginTitle)
        })

        MenuSection({
          MenuCell(text: L10n.securitySettingsDataProtection, disclosureIndicator: .externalLink, {
            openLink(L10n.securitySettingsDataProtectionLink)
          })

          ToggleMenuCell(text: L10n.securitySettingsShareAnalysis, subtitle: L10n.securitySettingsShareAnalysisText, isOn: $viewModel.isAnalyticsEnabled, isLoading: $viewModel.isLoading) {
            Task {
              await viewModel.updateAnalyticsStatus()
            }
          }
          .onAppear {
            viewModel.fetchAnalyticsStatus()
          }

          MenuCell(text: L10n.securitySettingsDataAnalysis, disclosureIndicator: .navigation) {
            viewModel.presentInformationView()
          }
          .hasDivider(false)
        }, header: {
          MenuHeader(image: "chart.pie", text: L10n.securitySettingsAnalysisTitle)
        })

        NavigationLink(destination: PinCodeChangeFlowView(isPresented: $viewModel.isPinCodeChangePresented), isActive: $viewModel.isPinCodeChangePresented) {
          EmptyView()
        }

        NavigationLink(destination: BiometricChangeFlowView(isPresented: $viewModel.isBiometricChangeFlowPresented, isBiometricEnabled: viewModel.isBiometricEnabled), isActive: $viewModel.isBiometricChangeFlowPresented) {
          EmptyView()
        }

        NavigationLink(destination: DataInformationView(), isActive: $viewModel.isInformationPresented) {
          EmptyView()
        }
      }
      .padding(.x4)
    }
    .navigationTitle(L10n.settingsSecurity)
    .navigationBackButtonDisplayMode(.minimal)
  }

  private func openLink(_ link: String) {
    guard let url = URL(string: link) else { return }
    UIApplication.shared.open(url)
  }
}
