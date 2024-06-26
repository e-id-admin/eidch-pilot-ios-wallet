import BITTheming
import Factory
import SwiftUI

public struct PresentationCredentialListView: View {

  // MARK: Lifecycle

  public init(viewModel: PresentationCredentialListViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: Public

  public var body: some View {
    VStack {
      switch viewModel.state {
      case .error:
        errorView
      case .results:
        resultView
      }
    }
    .font(.custom.body)
    .navigationBarHidden(true)
  }

  // MARK: Internal

  @StateObject var viewModel: PresentationCredentialListViewModel

  // MARK: Private

  @State private var listBottomPadding: CGFloat = 0

  private var resultView: some View {
    ZStack(alignment: .bottom) {
      ScrollView {
        VStack(alignment: .leading, spacing: .x6) {
          PresentationRequestHeaderView(verifier: viewModel.verifier)
            .padding(.top, .x6)
            .padding(.horizontal)

          VStack(alignment: .leading, spacing: .x2) {
            Text(L10n.presentationSelectCredentialTitle)
              .font(.custom.title)
            Text(L10n.presentationSelectCredentialSubtitle)
          }
          .padding(.horizontal)

          VStack(spacing: .x4) {
            CompatibleCredentialListView(credentials: viewModel.compatibleCredentials) { selectedCredential in
              Task {
                await viewModel.send(event: .didSelectCredential(selectedCredential))
              }
            }
          }
          .padding(.bottom, listBottomPadding)
        }
      }

      VStack {
        Button(action: {
          Task {
            await viewModel.send(event: .cancel)
          }
        }, label: {
          Label(L10n.globalBackHome, systemImage: "arrow.left")
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondary)
      }
      .background(ThemingAssets.background.swiftUIColor.ignoresSafeArea())
      .readSize { size in
        listBottomPadding = size.height
      }
      .padding(.x4)

      if let selectedCredential = viewModel.selectedCredential {
        NavigationLink(
          destination:
          PresentationRequestMetadataView(viewModel: Container.shared.presentationMetadataViewModel((viewModel.requestObject, selectedCredential, viewModel.completed ?? { }))),
          isActive: $viewModel.isMetadataPresented,
          label: {
            EmptyView()
          })
      }
    }
  }

  private var errorView: some View {
    EmptyStateView(.errorCustom(title: "Error getting credential list", message: viewModel.stateError.debugDescription)) {
      Text(L10n.globalClose)
    } action: {
      await viewModel.send(event: .close)
    }
  }
}
