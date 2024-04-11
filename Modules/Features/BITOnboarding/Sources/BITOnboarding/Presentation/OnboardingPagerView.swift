import BITAppAuth
import BITCore
import BITTheming
import Factory
import SwiftUI

// MARK: - OnboardingPagerView

struct OnboardingPagerView<Content: View>: View {

  // MARK: Lifecycle

  init(pageCount: Int, currentIndex: Binding<Int>, isSwipeEnabled: Binding<Bool>, isNextButtonEnabled: Binding<Bool>, areDotsEnabled: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self.pageCount = pageCount
    _currentIndex = currentIndex
    _isSwipeEnabled = isSwipeEnabled
    _isNextButtonEnabled = isNextButtonEnabled
    _areDotsEnabled = areDotsEnabled
    self.content = content()
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .leading) {
      Pager(pageCount: pageCount, currentIndex: $currentIndex, isSwipeEnabled: $isSwipeEnabled) {
        content
      }

      if areDotsEnabled {
        HStack {
          PagerDots(pageCount: pageCount, currentIndex: $currentIndex)

          Spacer()

          if isNextButtonEnabled {
            Button(action: {
              guard isNextButtonEnabled, currentIndex < pageCount - 1 else { return }
              isNextButtonEnabled = false // Will be set back to true in the index process (vm)
              currentIndex += 1
            }, label: {
              Image(systemName: "arrow.right")
                .padding()
                .foregroundStyle(ThemingAssets.background.swiftUIColor)
                .background(ThemingAssets.accentColor.swiftUIColor)
                .clipShape(Circle())
            })
          }
        }
        .padding(.horizontal, .x4)
        .padding(.bottom, .x4)
      }
    }
  }

  // MARK: Private

  private let pageCount: Int
  @Binding private var currentIndex: Int
  @Binding private var isSwipeEnabled: Bool
  @Binding private var isNextButtonEnabled: Bool
  @Binding private var areDotsEnabled: Bool
  private let content: Content

}

// MARK: - PagerDots

struct PagerDots: View {

  // MARK: Lifecycle

  init(pageCount: Int, currentIndex: Binding<Int>) {
    self.pageCount = pageCount
    _currentIndex = currentIndex
  }

  // MARK: Internal

  var body: some View {
    HStack(spacing: .x4) {
      ForEach(0..<pageCount, id: \.self) { pageIndex in
        Group {
          if currentIndex == pageIndex {
            Capsule()
              .frame(width: .x4, height: .x2)
              .foregroundStyle(ThemingAssets.accentColor.swiftUIColor)
          } else {
            Circle()
              .frame(width: .x2)
              .foregroundStyle(ThemingAssets.gray3.swiftUIColor)
          }
        }
      }
    }
  }

  // MARK: Private

  @Binding private var currentIndex: Int
  private let pageCount: Int

}
