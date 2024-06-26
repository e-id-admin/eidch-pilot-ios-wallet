import BITCredential
import BITTheming
import Factory
import SwiftUI

// MARK: - PresentationRequestMetadataView

public struct PresentationRequestMetadataView: View {

  // MARK: Lifecycle

  public init(viewModel: PresentationRequestMetadataViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  public var body: some View {
    content
      .font(.custom.body)
      .navigationBarHidden(true)
  }

  // MARK: Internal

  @StateObject var viewModel: PresentationRequestMetadataViewModel

  // MARK: Private

  @State private var listBottomPadding: CGFloat = 0

  private var content: some View {
    VStack {
      switch viewModel.state {
      case .error:
        PresentationErrorView {
          Task { await viewModel.send(event: .close) }
        } retry: {
          Task { await viewModel.send(event: .retry) }
        }
      case .results:
        resultsView
      case .invalidCredentialError:
        invalidCredentialErrorView
      }
    }
  }

  private var resultsView: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack {
          if let metadata = viewModel.presentationMetadata {
            PresentationRequestHeaderView(verifier: metadata.verifier)
              .padding(.vertical, .x6)
              .padding(.horizontal)
          }

          CredentialTinyCard(viewModel.selectedCredential.credential)

          if let attributes = viewModel.presentationMetadata?.attributes {
            VStack(alignment: .leading, spacing: .x6) {
              Text(L10n.presentationAttributesTitle)
                .font(.custom.headline)
              PresentationAttributeListView(attributes)
                .padding(.bottom, listBottomPadding)
            }
            .padding([.horizontal, .top], .x6)
          }
        }

        if let presentationMetadata = viewModel.presentationMetadata {
          NavigationLink(
            destination: PresentationResultView(presentationMetadata: presentationMetadata) {
              Task {
                await viewModel.send(event: .close)
              }
            },
            isActive: $viewModel.isResultViewPresented)
          {
            EmptyView()
          }
        }
      }

      VStack(alignment: .leading, spacing: .x3) {
        Button(action: {
          Task {
            await viewModel.send(event: .deny)
          }
        }, label: {
          Label(L10n.presentationDenyButtonText, systemImage: "xmark")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondary)
        .disabled(viewModel.isLoading)

        NavigationLink(destination: PresentationRequestDeclineView(onComplete: {
          Task {
            await viewModel.send(event: .close)
          }
        }), isActive: $viewModel.isRequestDeclineViewPresented) {
          EmptyView()
        }

        Button(action: {
          Task {
            await viewModel.send(event: .submit)
          }
        }, label: {
          if viewModel.isLoading {
            HStack(spacing: .standard) {
              ProgressView()
              Text(L10n.presentationSendButtonText)
            }
            .frame(maxWidth: .infinity)
          } else {
            Label(L10n.presentationAcceptButtonText, systemImage: "checkmark")
              .frame(maxWidth: .infinity)
          }
        })
        .buttonStyle(.primaryProminentSecondary)
        .disabled(viewModel.isLoading)
      }
      .padding(.x4)
      .background(ThemingAssets.background.swiftUIColor.ignoresSafeArea())
      .readSize { size in
        listBottomPadding = size.height
      }
    }
  }

  private var invalidCredentialErrorView: some View {
    VStack {
      if let attributes = viewModel.presentationMetadata?.attributes {
        PresentationInvalidErrorView(attributes: attributes)
      }

      Spacer()

      Button(action: {
        Task {
          await viewModel.send(event: .close)
        }
      }, label: {
        Label(L10n.globalBackHome, systemImage: "arrow.right")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(.secondary)
      .labelStyle(.titleAndIconReversed)
      .padding(.x4)
    }
  }
}
