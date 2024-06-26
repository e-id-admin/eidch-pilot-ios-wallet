import BITTheming
import SwiftUI

// MARK: - OnboardingPagerView

struct OnboardingPagerView<Content: View>: View {

  // MARK: Lifecycle

  init(pageCount: Int, currentIndex: Binding<Int>, isSwipeEnabled: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self.pageCount = pageCount
    _currentIndex = currentIndex
    _isSwipeEnabled = isSwipeEnabled
    self.content = content()
  }

  // MARK: Internal

  var body: some View {
    Pager(pageCount: pageCount, currentIndex: $currentIndex, isSwipeEnabled: $isSwipeEnabled) {
      content
    }
  }

  // MARK: Private

  private let pageCount: Int
  private let content: Content
  @Binding private var currentIndex: Int
  @Binding private var isSwipeEnabled: Bool
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

  private let pageCount: Int
  @Binding private var currentIndex: Int
}
