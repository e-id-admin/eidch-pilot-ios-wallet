import BITCore
import BITCredential
import BITPresentation
import BITTheming
import Factory
import PopupView
import SwiftUI

// MARK: - InvitationView

public struct InvitationView: View {

  // MARK: Lifecycle

  public init(isPresented: Binding<Bool> = .constant(true)) {
    _isPresented = isPresented
    _viewModel = .init(wrappedValue: Container.shared.invitationViewModel())
  }

  public init(viewModel: InvitationViewModel) {
    _isPresented = .constant(true)
    _viewModel = .init(wrappedValue: viewModel)
  }

  // MARK: Public

  public var body: some View {
    content()
      .font(.custom.body)
      .navigationTitle(L10n.qrScannerTitle)
      .navigationBarTitleDisplayMode(.inline)
      .animation(.default, value: viewModel.state)
      .animation(.default, value: viewModel.isLoading)
  }

  // MARK: Private

  @StateObject private var viewModel: InvitationViewModel
  @Binding private var isPresented: Bool

  @ViewBuilder
  private func content() -> some View {
    VStack {
      switch viewModel.state {
      case .loading:
        ProgressView()
      case .permission:
        CameraPermissionView(isPresented: $isPresented, viewModel: Container.shared.cameraPermissionViewModel({
          Task {
            await viewModel.send(event: .cameraPermissionIsAuthorized)
          }
        }))
        .navigationBarHidden(true)
        .transition(.opacity)
      case .qrScanner:
        ZStack(alignment: .center) {
          ScannerView(
            metadataUrl: $viewModel.metadataUrl,
            isTorchAvailable: $viewModel.isTorchAvailable,
            isTorchEnabled: $viewModel.isTorchEnabled,
            error: $viewModel.qrScannerError)

          progressView()
        }
        .navigationBarHidden(false)
        .popup(isPresented: $viewModel.isPopupErrorPresented, view: {
          errorToast()
        }, customize: {
          $0.position(.top).appearFrom(.top).animation(.spring).dragToDismiss(true).closeOnTap(true).autohideIn(5).type(.toast)
        })

      case .emptyWallet:
        errorView(image: Assets.emptyWallet.swiftUIImage, title: L10n.presentationErrorEmptyWalletTitle, message: L10n.presentationErrorEmptyWalletMessage, url: L10n.presentationErrorEmptyWalletSupportLink, urlText: L10n.presentationErrorEmptyWalletSupportText)

      case .noCompatibleCredentials:
        errorView(image: Assets.wrongCredential.swiftUIImage, title: L10n.presentationErrorNoCompatibleCredentialTitle, message: L10n.presentationErrorNoCompatibleCredentialMessage)

      case .wrongIssuer:
        errorView(image: Assets.unbekanntenAussteller.swiftUIImage, title: L10n.invitationErrorWrongIssuerTitle, message: L10n.invitationErrorWrongIssuerMessage)

      case .wrongVerifier:
        errorView(image: Assets.unbekanntenAussteller.swiftUIImage, title: L10n.invitationErrorWrongVerifierTitle, message: L10n.invitationErrorWrongVerifierMessage)

      case .credentialMismatch:
        errorView(image: Assets.wrongCredential.swiftUIImage, title: L10n.invitationErrorCredentialMismatchTitle, message: L10n.invitationErrorCredentialMismatchMessage)

      case .expiredInvitation:
        expiredInvitationView(image: Assets.wrongCredential.swiftUIImage, title: L10n.invitationErrorCredentialExpiredTitle, message: L10n.invitationErrorCredentialExpiredMessage)
      case .noInternetConnexion:
        noInternetConnexionErrorView(image: Assets.noInternet.swiftUIImage, title: L10n.emptyStateOfflineTitle, message: L10n.emptyStateOfflineMessage)
      }

      if let credential = viewModel.credential {
        NavigationLink(destination: CredentialOfferView(viewModel: Container.shared.credentialOfferViewModel((credential, nil, $isPresented))), isActive: $viewModel.isOfferPresented) {
          EmptyView()
        }
      }

      if let requestObject = viewModel.requestObject {
        if viewModel.isPresentationPresented, let credential = viewModel.compatibleCredentials.first {
          NavigationLink(destination: PresentationRequestMetadataView(
            viewModel: Container.shared.presentationMetadataViewModel((requestObject, credential, { isPresented = false }))
          ), isActive: $viewModel.isPresentationPresented) {
            EmptyView()
          }
        } else if viewModel.isCredentialSelectionPresented {
          NavigationLink(destination: PresentationCredentialListView(
            viewModel: Container.shared.presentationCredentialListViewModel((requestObject, viewModel.compatibleCredentials, { isPresented = false }))
          ), isActive: $viewModel.isCredentialSelectionPresented) {
            EmptyView()
          }
        }
      }
    }
  }
}

extension InvitationView {

  @ViewBuilder
  private func expiredInvitationView(image: Image, title: String, message: String) -> some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x6) {
          errorViewContent(image: image, title: title, message: message)
          if let url = URL(string: L10n.invitationErrorCredentialExpiredMoreInfoLink) {
            Link(destination: url, label: {
              LinkText(L10n.invitationErrorCredentialExpiredMoreInfoTitle)
            })
          }
          Spacer()
        }
      }
      errorViewButtons()
    }
    .padding()
    .navigationBarHidden(true)
  }

  @ViewBuilder
  private func noInternetConnexionErrorView(image: Image, title: String, message: String) -> some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x6) {
          errorViewContent(image: image, title: title, message: message)
          Spacer()
        }
      }

      VStack(spacing: .x2) {
        Button {
          isPresented = false
          Task {
            await viewModel.send(event: .close)
          }
        } label: {
          Label(L10n.globalBackHome, systemImage: "arrow.backward")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.secondary)

        Button {
          Task {
            await viewModel.send(event: .retry)
          }
        } label: {
          Label(L10n.emptyStateOfflineRetryButton, systemImage: "arrow.triangle.2.circlepath")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.primaryProminent)
      }
      .background(ThemingAssets.background.swiftUIColor)
    }
    .padding()
    .navigationBarHidden(true)
  }

  @ViewBuilder
  private func progressView() -> some View {
    VStack {
      ZStack {
        VisualEffectView(effect: UIBlurEffect(style: .extraLight))

        ProgressView()
          .scaleEffect(2)
      }
      .frame(width: 150, height: 150)
      .clipShape(.rect(cornerRadius: .x4))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
    .background(Color.black.opacity(0.4).ignoresSafeArea(edges: [.bottom, .horizontal]))
    .opacity(viewModel.isLoading ? 1 : 0)
  }

  @ViewBuilder
  private func errorToast() -> some View {
    VStack(alignment: .leading) {
      Label(L10n.qrScannerErrorMessage, systemImage: "exclamationmark.triangle")
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity)
    }
    .padding(.x4)
    .background(ThemingAssets.red3.swiftUIColor)
    .foregroundColor(ThemingAssets.red.swiftUIColor)
    .clipShape(.rect(cornerRadius: .x1))
    .padding(.horizontal)
    .padding(.top, 60 + .x6)
  }

  @ViewBuilder
  private func errorView(image: Image, title: String, message: String, url: String? = nil, urlText: String? = nil) -> some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack {
          errorViewContent(image: image, title: title, message: message, url: url, urlText: urlText)
          Spacer()
        }
      }
      errorViewButtons()
    }
    .padding()
    .navigationBarHidden(true)
  }

  @ViewBuilder
  private func errorViewContent(image: Image, title: String, message: String, url: String? = nil, urlText: String? = nil) -> some View {
    VStack(alignment: .leading, spacing: .x6) {
      image
        .resizable()
        .scaledToFit()
        .frame(maxHeight: 300)
      Text(title)
        .font(.custom.title)
      Text(message)

      if let url, let destinationURL = URL(string: url), let urlText {
        Link(destination: destinationURL) {
          LinkText(urlText)
        }
      }
    }
  }

  @ViewBuilder
  private func errorViewButtons() -> some View {
    VStack {
      Button {
        isPresented = false
        Task {
          await viewModel.send(event: .close)
        }
      } label: {
        Label(L10n.globalBackHome, systemImage: "arrow.backward")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.secondary)
    }
    .background(ThemingAssets.background.swiftUIColor)
  }
}
