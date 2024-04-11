import SwiftUI

struct CredentialsEmptyStateView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: .x4) {
      HomeAssets.home.swiftUIImage
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxHeight: 300)

      Text(L10n.homeEmptyViewHadCredentialsText)
    }
    .padding(.horizontal, .x4)
    .padding(.top, .x15)
  }
}

#Preview {
  CredentialsEmptyStateView()
}
