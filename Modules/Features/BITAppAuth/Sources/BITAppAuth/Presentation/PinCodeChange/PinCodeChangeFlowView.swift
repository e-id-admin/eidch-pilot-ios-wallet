import BITTheming
import Factory
import SwiftUI

// MARK: - PinCodeChangeView

public struct PinCodeChangeFlowView: View {

  // MARK: Lifecycle

  public init(isPresented: Binding<Bool>) {
    _viewModel = StateObject(wrappedValue: Container.shared.pinCodeChangeFlowViewModel(isPresented))
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: .leading) {
      PinCodeChangePagerView(pageCount: PinCodeChangeStep.allCases.count, currentIndex: $viewModel.currentIndex) {
        pinCodeView(title: L10n.pinChangeCurrentPasswordTitle, pinCode: $viewModel.currentPinCode, state: viewModel.currentPinCodeState)

        pinCodeView(title: L10n.pinChangeNewPinTitle, pinCode: $viewModel.newPinCode, state: .normal)

        pinCodeView(title: L10n.pinChangeNewPinConfirmationTitle, pinCode: $viewModel.newPinCodeConfirmation, state: viewModel.newPinCodeConfirmationState, withBackButton: true)
          .keyPadLeftKey(.cancel) {
            viewModel.backToPin()
          }
      }
    }
    .padding(.top, .x5)
    .clipped()
    .navigationTitle(L10n.pinChangeTitle)
    .navigationBackButtonDisplayMode(.minimal)
  }

  // MARK: Internal

  @StateObject var viewModel: PinCodeChangeFlowViewModel

  // MARK: Private

  @ViewBuilder
  private func pinCodeView(title: String, pinCode: Binding<String>, state: PinCodeState, withBackButton: Bool = false, completion: (() -> Void)? = nil) -> some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.custom.title)
      PinCodeView(pinCode: pinCode, state: state)
    }
    .padding(.horizontal, .x4)
  }

}

#Preview {
  PinCodeChangeFlowView(isPresented: .constant(true))
}
