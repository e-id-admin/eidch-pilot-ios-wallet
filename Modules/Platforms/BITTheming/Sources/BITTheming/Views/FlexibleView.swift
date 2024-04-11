import Foundation
import SwiftUI

// MARK: - TagList

// https://www.fivestars.blog/articles/flexible-swiftui/

public struct TagList<Data: Collection, Content: View>: View where Data.Element: Hashable {

  // MARK: Lifecycle

  public init(data: Data, spacing: CGFloat, alignment: HorizontalAlignment, content: @escaping (Data.Element) -> Content, availableWidth: CGFloat = 0) {
    self.data = data
    self.spacing = spacing
    self.alignment = alignment
    self.content = content
    self.availableWidth = availableWidth
  }

  // MARK: Public

  public var body: some View {
    ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
      Color.clear
        .frame(height: 1)
        .readSize { size in
          availableWidth = size.width
        }

      TagListInternal(
        availableWidth: availableWidth,
        data: data,
        spacing: spacing,
        alignment: alignment,
        content: content)
    }
  }

  // MARK: Internal

  let data: Data
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content

  // MARK: Private

  @State private var availableWidth: CGFloat = 0

}

// MARK: - TagListInternal

public struct TagListInternal<Data: Collection, Content: View>: View where Data.Element: Hashable {

  // MARK: Lifecycle

  public init(availableWidth: CGFloat, data: Data, spacing: CGFloat, alignment: HorizontalAlignment, content: @escaping (Data.Element) -> Content, elementsSize: [Data.Element: CGSize] = [:]) {
    self.availableWidth = availableWidth
    self.data = data
    self.spacing = spacing
    self.alignment = alignment
    self.content = content
    self.elementsSize = elementsSize
  }

  // MARK: Public

  public var body: some View {
    VStack(alignment: alignment, spacing: spacing) {
      ForEach(computeRows(), id: \.self) { rowElements in
        HStack(spacing: spacing) {
          ForEach(rowElements, id: \.self) { element in
            content(element)
              .fixedSize()
              .readSize { size in
                elementsSize[element] = size
              }
          }
        }
      }
    }
  }

  // MARK: Internal

  let availableWidth: CGFloat
  let data: Data
  let spacing: CGFloat
  let alignment: HorizontalAlignment
  let content: (Data.Element) -> Content
  @State var elementsSize: [Data.Element: CGSize] = [:]

  func computeRows() -> [[Data.Element]] {
    var rows: [[Data.Element]] = [[]]
    var currentRow = 0
    var remainingWidth = availableWidth

    for element in data {
      let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

      if remainingWidth - (elementSize.width + spacing) >= 0 {
        rows[currentRow].append(element)
      } else {
        currentRow = currentRow + 1
        rows.append([element])
        remainingWidth = availableWidth
      }

      remainingWidth = remainingWidth - (elementSize.width + spacing)
    }

    return rows
  }
}
