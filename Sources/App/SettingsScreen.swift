// SettingsScreen.swift
import SwiftUI

struct SettingsScreen: View {
    @State private var settings = AppSettings.shared
    
    @State private var urlText = ""
    @State private var portText = ""
    
    var parsedURL: URL? {
        URL(string: urlText).flatMap {
            ($0.scheme == "http" || $0.scheme == "https") && $0.host != nil ? $0 : nil
        }
    }
    var parsedPort: UInt16? { UInt16(portText) }
    
    var body: some View {
        NavigationStack {
            Group {
                Divider()
                VStack {
                    Text(
                    """
                    *Toggles take effect instantly, while port & host settings require clicking the button to update, since they must be checked for correctness.*
                    """
                    )
                    Toggle(isOn: $settings.userPreferences.isVerbose) {
                        Text("Verbose Mode")
                    }.onChange(of: settings.userPreferences.isVerbose) {
                        try? settings.save()
                    }
                    // TODO: finish up this part
                    TextField("http://localhost", text: $urlText)
                        .border(parsedURL == nil && !urlText.isEmpty ? .red : .clear)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    TextField("Port", text: $portText)
                        .border(parsedPort == nil && !portText.isEmpty ? .red : .clear)
                        .keyboardType(.numberPad)
                    // TODO: error handling on invalid state
                    Button { try? settings.save() } label: {
                        Text("Save Server Options")
                    }.buttonStyle(.glassProminent)
                }.padding([.leading,.trailing],16)
                Spacer()
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

