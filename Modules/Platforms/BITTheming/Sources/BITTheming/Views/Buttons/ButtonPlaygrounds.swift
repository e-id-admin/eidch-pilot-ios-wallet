import SwiftUI

// MARK: - ButtonLibrary

private struct ButtonPlaygrounds: View {

  @State var isHidden = false

  var body: some View {
    ScrollView {
      VStack {
        Button(action: { isHidden.toggle() }, label: {
          Label(title: { Text("Scan") }, icon: { Image(systemName: "qrcode.viewfinder") })
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminent)
        Button(action: { isHidden.toggle() }, label: {
          Label(title: { Text("Scan") }, icon: { Image(systemName: "qrcode.viewfinder") })
            .frame(maxWidth: .infinity)
        })
        .disabled(true)
        .buttonStyle(.primaryProminent)

        Button(action: { isHidden.toggle() }, label: {
          Label(title: { Text("Scan") }, icon: { Image(systemName: "qrcode.viewfinder") })
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminentSecondary)

        Button(action: { isHidden.toggle() }, label: {
          HStack(spacing: .standard) {
            ProgressView()
            Text("Send it !")
          }
          .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primaryProminentSecondary)
        Button(action: { isHidden.toggle() }, label: {
          HStack(spacing: .standard) {
            ProgressView()
            Text("Sending")
          }
          .frame(maxWidth: .infinity)
        })
        .disabled(true)
        .buttonStyle(.primaryProminentSecondary)

        Button(action: { isHidden.toggle() }, label: {
          Label(title: { Text("Scan") }, icon: { Image(systemName: "qrcode.viewfinder") })
            .frame(maxWidth: .infinity)
        })
        .disabled(true)
        .buttonStyle(.primaryProminentSecondary)

        Button(action: { isHidden.toggle() }, label: {
          Label(title: { Text("Close") }, icon: { Image(systemName: "xmark") })
            .frame(maxWidth: .infinity)
        })
        .buttonStyle(.secondary)
        Button(action: { isHidden.toggle() }, label: {
          Label(title: { Text("Close") }, icon: { Image(systemName: "xmark") })
            .frame(maxWidth: .infinity)
        })
        .disabled(true)
        .buttonStyle(.secondary)

        VStack {
          Button(action: { isHidden.toggle() }, label: {
            Label(title: { Text("Lights on !") }, icon: { Image(systemName: "lightbulb") })
          })
          .buttonStyle(.primary)
          Button(action: { isHidden.toggle() }, label: {
            Label(title: { Text("Lights on !") }, icon: { Image(systemName: "lightbulb") })
          })
          .disabled(true)
          .buttonStyle(.primary)
        }

        VStack {
          Button(action: { isHidden.toggle() }, label: {
            Label(title: { Text("Lights on !") }, icon: { Image(systemName: "lightbulb") })
          })
          .buttonStyle(.primaryReversed)
          Button(action: { isHidden.toggle() }, label: {
            Label(title: { Text("Lights on !") }, icon: { Image(systemName: "lightbulb") })
          })
          .disabled(true)
          .buttonStyle(.primaryReversed)
        }
        .padding()
        .background(Color.black)
      }.padding()
    }
  }
}

#Preview {
  ButtonPlaygrounds()
}
