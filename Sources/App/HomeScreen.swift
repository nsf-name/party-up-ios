// HomeScreen.swift
import SwiftUI

struct HomeScreen: View {
    @State private var settings = AppSettings.shared
    
    var body: some View {
        NavigationStack {
            Group {
                VStack {
                    Divider()
                    Text(
                    """
                    **Hello from [Party UP (iOS Edition)](https://github.com/nsf-name/party-up-ios)!** *version v0.5*
                    
                    This app lets you upload files (images, videos) to a [copyparty](https://github.com/9001/copyparty) server.
                    
                    **Use your favorite app to open content you'd like to share, then hit the share button and select "Party UP!" from the share menu 🎉**
                    
                    You can also share things like YouTube videos; the app will then upload a message with the link. The [copyparty](https://github.com/9001/copyparty) server can be configured to log these for later viewing.
                    
                    Fun fact: You can run the copyparty server itself on any device where Python is available -- and thanks to [aShell](https://github.com/holzschu/a-shell), that includes iOS devices :>
                    """
                    ).padding([.leading,.trailing],16)
                    NavigationLink(destination: SendScreen()) {
                        Label("Send Files", systemImage: "folder")
                    }.buttonStyle(.glassProminent)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(destination: SettingsScreen()) {
                        Label("Open Settings", systemImage: "gear")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    NavigationLink(destination: LogScreen()) {
                        Label("Open Logs", systemImage: "doc.text")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    NavigationLink(destination: WizardScreen()) {
                        Label("Setup Wizard", systemImage: "wand.and.sparkles")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    NavigationLink(destination: AboutScreen()) {
                        Label("About Page", systemImage: "book.closed")
                    }
                }
            }
            .navigationSubtitle(Text("Simple iOS copyparty server client"))
            .navigationTitle(Text("Party UP! 🎉"))
        }
    }
}

