// NetPath.swift
import SwiftUI
import Network

struct NetCondition: Codable, Sendable, Equatable {
    var supportsDNS: Bool = false
    var supportsIPv4: Bool = false
    var supportsIPv6: Bool = false
    var isExpensive: Bool = false
    var isConstrained: Bool = false
}

struct NetPath: Codable, Sendable, Equatable {
    var online: Bool = false
    var conditions: NetCondition = NetCondition()
}

@MainActor
@Observable
final class NetworkMonitor {
    let pathMonitor = NWPathMonitor()
    var netState: NetPath
    
    @MainActor static let shared = NetworkMonitor()
    
    init() {
        // make no initial assumptions
        netState = NetPath()
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            DispatchQueue.main.async {
                let currentState: NetPath = .init(
                    online: path.status == .satisfied,
                    conditions: NetCondition(
                        supportsDNS: path.supportsDNS,
                        supportsIPv4: path.supportsIPv4,
                        supportsIPv6: path.supportsIPv6,
                        isExpensive: path.isExpensive,
                        isConstrained: path.isConstrained
                    )
                )
                self.netState = currentState
            }
        }
        pathMonitor.start(queue: .global())
    }
    
    // obj-c code needs manual free() for kernel resources
    deinit { pathMonitor.cancel() }
}
