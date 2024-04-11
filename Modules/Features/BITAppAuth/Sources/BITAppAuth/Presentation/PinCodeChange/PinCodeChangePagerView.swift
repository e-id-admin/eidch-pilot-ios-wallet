import BITTheming
import Foundation
import SwiftUI

struct PinCodeChangePagerView<Content: View>: View {

  // MARK: Lifecycle

  init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
    self.pageCount = pageCount
    _currentIndex = currentIndex
    self.content = content()
  }

  // MARK: Internal

  var body: some View {
    VStack(alignment: .leading) {
      Pager(pageCount: pageCount, currentIndex: $currentIndex, isSwipeEnabled: .constant(false)) {
        content
      }
    }
  }

  // MARK: Private

  private let pageCount: Int
  @Binding private var currentIndex: Int
  private let content: Content

}
