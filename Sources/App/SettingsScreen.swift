// SettingsScreen.swift
import SwiftUI
import Network

struct SettingsScreen: View {
    @State private var settings = AppSettings.shared
    
    @State private var urlText = ""
    @State private var portText = ""
    
    // this is very not RFC1123 but it gets the job done
    var parsedURL: URL? {
        URL(string: urlText).flatMap {
            ($0.scheme == "http" || $0.scheme == "https") && $0.host != nil ? $0 : nil
        }
    }
    var parsedPort: UInt16? { UInt16(portText) }
    
    // TODO: it would be really nice to allow the user to set options independently
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
                        if settings.userPreferences.isVerbose {
                            coreLogger.info("user has enabled verbose mode")
                        } else {
                            coreLogger.info("user has disabled verbose mode")
                        }
                        try? settings.save()
                    }
                    HStack {
                        Text("Host")
                            .padding(.trailing, 4)
                        TextField(settings.userPreferences.serverURL.absoluteString, text: $urlText)
                            .border(parsedURL == nil && !urlText.isEmpty ? .red : .blue)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.URL)
                            .padding(.leading, 4)
                    }
                    HStack {
                        Text("Port")
                            .padding(.trailing, 4)
                        TextField(settings.userPreferences.serverPort.description, text: $portText)
                            .border(parsedPort == nil && !portText.isEmpty ? .red : .blue)
                            .autocorrectionDisabled(true)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading, 4)
                    }
                    Button {
                        // we set our validated versions manually
                        AppSettings.shared.userPreferences.serverURL = parsedURL!
                        AppSettings.shared.userPreferences.serverPort = parsedPort!
                        coreLogger.info("user has changed server settings to url: \(parsedURL!) and port: \(parsedPort!)")
                        try? settings.save()
                    } label: {
                        Text("Save Server Options")
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(parsedURL == nil || parsedPort == nil)
                }.padding([.leading,.trailing],16)
                Spacer()
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

