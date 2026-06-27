// LogScreen.swift
import OSLog
import SwiftUI

struct LogScreen: View {
    @State private var logText = ""
    @State private var isLoaded: Bool = false
    static private let template = NSPredicate(format: "(subsystem BEGINSWITH $PREFIX) || (subsystem IN $SYSTEM)")
    
    // adapted from https://useyourloaf.com/blog/fetching-oslog-messages-in-swift/
    @MainActor
    private func fetchLogs() async -> String {
      self.isLoaded = false
      let calendar = Calendar.current
      guard let dayAgo = calendar.date(byAdding: .day,
        value: -1, to: Date.now) else {
          // this branch should never occur. if you reach this somehow,
          // please lend me your time machine!
        self.isLoaded = true
        return "Error: Invalid system calendar."
      }
        
      do {
        let predicate = LogScreen.template.withSubstitutionVariables([
              "PREFIX": "com.nsf-name.PartyUP", "SYSTEM": ["com.apple.coredata"]
          ])

        let logs = try await Logger.fetch(since: dayAgo,
          predicateFormat: predicate.predicateFormat)
        self.isLoaded = true
        return logs.joined()
      } catch {
        self.isLoaded = true
        return error.localizedDescription
      }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                ScrollView {
                    Divider()
                    Group {
                        if !isLoaded {
                            HStack {
                                Text("Loading, please wait...")
                                    .font(.system(.caption, design: .monospaced))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                ProgressView()
                            }.padding([.leading,.trailing],16)
                        } else {
                            Text(logText)
                                .textSelection(.enabled)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.leading,.trailing],16)
                        }
                    }.animation(.easeInOut, value: isLoaded)
                }.task { logText = await fetchLogs() }
            }
            .navigationSubtitle(Text("See exactly what's up"))
            .navigationTitle(Text("Logs"))
        }
    }
}
