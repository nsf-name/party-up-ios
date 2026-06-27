// Logging.swift
import OSLog

let coreLogger = Logger.init(
    subsystem: "com.nsf-name.PartyUP.Core",
    category: "PartyUP.Core"
)

let upLogger = Logger.init(
    subsystem: "com.nsf-name.PartyUP.Uploader",
    category: "PartyUP.Uploader"
)

let netLogger = Logger.init(
    subsystem: "com.nsf-name.PartyUP.Network",
    category: "PartyUP.Network"
)

// thanks to https://useyourloaf.com/blog/fetching-oslog-messages-in-swift/
// for making OSLog much more bearable. why not swift-log? thread-safety.

extension OSLogEntryLog.Level {
  fileprivate var description: String {
    switch self {
        case .undefined: "Undefined"
        case .debug: "Debug"
        case .info: "Info"
        case .notice: "Notice"
        case .error: "Error [!!!]"
        case .fault: "Fault"
        @unknown default: "Default"
    }
  }
}

extension Logger {
  static public func fetch(since date: Date,
    predicateFormat: String) async throws -> [String] {
    let store = try OSLogStore(scope: .currentProcessIdentifier)
    let position = store.position(date: date)
    let predicate = NSPredicate(format: predicateFormat)
    let entries = try store.getEntries(at: position,
      matching: predicate)
    
    var logs: [String] = []
    for entry in entries {
      try Task.checkCancellation()
      if let log = entry as? OSLogEntryLog {
        logs.append("""
          ###
          \(entry.date):\n\
          \(log.category): (\(log.level.description)):\n\
          \(entry.composedMessage)\n\
          ###
          """)
      } else {
        logs.append("\(entry.date): \(entry.composedMessage)\n")
      }
    }
    // should never occur!
    if logs.isEmpty { logs = ["Error: Nothing found!"] }
    return logs
  }
}
