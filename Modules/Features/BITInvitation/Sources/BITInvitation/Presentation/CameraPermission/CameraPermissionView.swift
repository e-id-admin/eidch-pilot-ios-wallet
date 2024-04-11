import BITCore
import BITTheming
import Factory
import Foundation
import SwiftUI

struct CameraPermissionView: View {

  // MARK: Lifecycle

  init(isPresented: Binding<Bool> = .constant(true), viewModel: CameraPermissionViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _isPresented = isPresented
  }

  // MARK: Internal

  @StateObject var viewModel: CameraPermissionViewModel
  @Binding var isPresented: Bool
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    content
      .font(.custom.body)
      .navigationTitle(L10n.cameraPermissionTitle)
  }

  // MARK: Private

  private var content: some View {
    Group {
      switch viewModel.state {
      case .authorized:
        EmptyView()
      case .notDetermined:
        ZStack(alignment: .bottom) {
          ScrollView {
            VStack(alignment: .leading, spacing: .x6) {
              Assets.cameraPermission.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
              Text(L10n.cameraPermissionNotDeterminedTitle)
                .font(.custom.title)
              Text(L10n.cameraPermissionNotDeterminedMessage)
              Spacer()
            }
          }

          VStack {
            Button(action: {
              isPresented.toggle()
            }, label: {
              Label(L10n.globalBackHome, systemImage: "arrow.backward")
                .frame(maxWidth: .infinity)
            })
            .buttonStyle(.secondaryProminant)

            Button(action: {
              Task {
                await viewModel.send(event: .allowCamera)
              }
            }, label: {
              Label(L10n.cameraPermissionNotDeterminedAllowButton, systemImage: "checkmark")
                .frame(maxWidth: .infinity)
            })
            .buttonStyle(.primaryProminentSecondary)
          }
          .background(ThemingAssets.background.swiftUIColor)
        }
        .padding(.x4)
      case .denied,
           .restricted:
        ZStack(alignment: .bottom) {
          ScrollView {
            VStack(alignment: .leading, spacing: .x6) {
              Assets.cameraPermissionNotAllowed.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 300)
              Text(L10n.cameraPermissionDeniedTitle)
                .font(.custom.title)
              Text(L10n.cameraPermissionDeniedMessage)
              Spacer()
            }
          }

          VStack {
            Button(action: {
              isPresented.toggle()
            }, label: {
              Label(L10n.globalBackHome, systemImage: "arrow.backward")
                .frame(maxWidth: .infinity)
            })
            .buttonStyle(.secondaryProminant)

            Button(action: {
              Task {
                await viewModel.send(event: .openSettings)
              }
            }, label: {
              HStack {
                Text(L10n.cameraPermissionDeniedSettingsButton)
                Image(systemName: "arrow.up.right")
              }
              .frame(maxWidth: .infinity)
            })
            .buttonStyle(.primaryProminent)
          }
          .background(ThemingAssets.background.swiftUIColor)
        }
        .padding(.x4)
      @unknown default:
        EmptyStateView(.error(error: CameraPermissionError.missingPermissionCase)) {
          Text(L10n.globalClose)
        } action: {
          isPresented.toggle()
        }
      }
    }
  }

}

#Preview {
  CameraPermissionView(viewModel: .init())
}
