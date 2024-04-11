import Foundation
import SwiftUI

public struct Pager<Content: View>: View {

  // MARK: Lifecycle

  public init(pageCount: Int, currentIndex: Binding<Int>, isSwipeEnabled: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self.pageCount = pageCount
    _currentIndex = currentIndex
    _isSwipeEnabled = isSwipeEnabled
    self.content = content()
  }

  // MARK: Public

  public var body: some View {
    GeometryReader { geometry in
      HStack(spacing: 0) {
        content.frame(width: geometry.size.width)
      }
      .frame(width: geometry.size.width, alignment: .leading)
      .offset(x: -CGFloat(currentIndex) * geometry.size.width)
      .offset(x: translation)
      .animation(.interactiveSpring(), value: currentIndex)
      .animation(.interactiveSpring(), value: translation)
      .gesture(
        DragGesture().updating($translation) { value, state, _ in
          if isSwipeEnabled {
            state = value.translation.width
          }
        }.onEnded { value in
          if isSwipeEnabled {
            let offset = value.translation.width / geometry.size.width * 2
            let index = (CGFloat(currentIndex) - offset).rounded()
            currentIndex = min(max(Int(index), 0), pageCount - 1)
          }
        }
      )
    }
  }

  // MARK: Private

  @Binding private var currentIndex: Int
  @Binding private var isSwipeEnabled: Bool

  private let pageCount: Int
  private let content: Content

  @GestureState private var translation: CGFloat = 0
}
