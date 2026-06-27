// WizardScreen.swift
import SwiftUI

struct WizardScreen: View {
    @State private var settings = AppSettings.shared
    private var net = NetworkMonitor.shared.netState
    
    enum partyState {
        case good
        case bad
        case concerns
    }
    
    func partyAdvice() -> (partyState, String) {
        // TODO: maybe ping the server to see if it's reachable?
        // a bit more expensive than NetPath so we might want to make that opt-in.
        if !net.online {
            return (.bad, "No connection")
        }
        if !net.conditions.supportsIPv4 {
            return (.concerns, "No IPv4 connectivity")
        }
        if !net.conditions.supportsIPv6 {
            return (.concerns, "No IPv6 connectivity")
        }
        if !net.conditions.supportsDNS {
            return (.concerns, "No DNS server available")
        }
        if net.conditions.isExpensive && net.conditions.isConstrained {
            return (.concerns, "Limited bandwidth or in Low Data Mode")
        }
        return (.good, "Ready to party 🎉")
    }
    
    // TODO: properly animate this view so it looks less jank on transitions
    var body: some View {
        let advice = partyAdvice()
        
        NavigationStack {
            Group {
                VStack {
                    Divider()
                    Group {
                        if net.online {
                            Label("We are online (stable Internet connection)", systemImage: "checkmark.circle")
                        } else {
                            Label("We are offline (no connection)", systemImage: "x.circle")
                        }
                        if net.conditions.supportsIPv4 || net.conditions.supportsIPv6 {
                            if net.conditions.supportsIPv6 && net.conditions.supportsIPv4 {
                                Label("Connection supports IPv6 and IPv4", systemImage: "checkmark.circle")
                            } else if net.conditions.supportsIPv4 {
                                Label("Connection supports IPv4, but not IPv6", systemImage: "x.circle")
                            } else if net.conditions.supportsIPv6 {
                                Label("Connection supports IPv6, but not IPv4", systemImage: "x.circle")
                            }
                        } else {
                            Label("Connection fails for both IPv6 and IPv4", systemImage: "x.circle")
                        }
                        if net.conditions.supportsDNS {
                            Label("Connection supports DNS", systemImage: "checkmark.circle")
                        } else {
                            Label("Connection does not support DNS", systemImage: "x.circle")
                        }
                        if net.conditions.isConstrained || net.conditions.isExpensive {
                            Label("On a metered mobile connection and/or Low Data Mode", systemImage: "x.circle")
                        } else {
                            Label("On an unmetered connection", systemImage: "checkmark.circle")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],16)
                    Divider()
                    Group {
                        switch advice.0 {
                        case .good:
                        Text("**Ready to party 🎉**")
                        case .bad:
                        Text("**Unable to party ‼️**\n*\(advice.1)*")
                        case .concerns:
                        Text("**Ready to party 🎉**\n*(Note: \(advice.1))*")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading,.trailing],16)
                    Divider()
                    Text(
                    """
                    This allows you to check for common connection issues that might be hindering you from uploading to the copyparty server. If everything is working fine, feel free to ignore anything this page says. Not all advice here is relevant to every configuration.
                    
                    If you can't connect and the cause isn't listed on this screen, please send the app's logs because that is a bug. See the About screen for information on how to send them.
                    """
                    )
                    .padding([.leading,.trailing], 16)
                    Spacer()
                }
            }
            .navigationSubtitle(Text("Quickly diagnose common issues"))
            .navigationTitle(Text("Setup"))
        }
    }
}

