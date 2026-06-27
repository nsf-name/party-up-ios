// SendScreen.swift
import SwiftUI

struct SendScreen: View {
    let payload: SendPayload
    
    var body: some View {
        @State var sendManager = SendManager(payload)
        // TODO: handle errors better here
        NavigationStack {
            Group {
                VStack {
                    Divider()
                    switch payload {
                    case .failure(let error):
                        Text("An unexpected error occured: \(error)")
                            .padding([.leading,.trailing], 16)
                    case .success:
                        Text("You are about to upload the following files (total size \(sendManager.totalSize)):")
                            .padding([.leading,.trailing], 16)
                        Text(sendManager.files.map(\.name).joined(separator: "\n"))
                            .font(.system(.caption, design: .monospaced))
                            .padding([.leading,.trailing], 16)
                            .padding(.top, 8)
                        Button {
                            // TODO: draw the rest of the Owl
                        } label: {
                            Label("Confirm & Send", systemImage: "paperplane")
                        }
                        .buttonStyle(.glassProminent)
                        .padding(.top, 8)
                    }
                    Spacer()
                }
            }
            .navigationSubtitle(Text("Upload to copyparty"))
            .navigationTitle(Text("Send Files"))
        }
    }
}

