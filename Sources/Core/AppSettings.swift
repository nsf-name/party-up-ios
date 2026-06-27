// AppSettings.swift
import Foundation

struct UserPreferences: Codable, Sendable {
    var serverURL: URL = URL(string: "http://127.0.0.1")!
    var serverPort: UInt16 = 3923
    var isVerbose: Bool = false
}

@Observable
final class AppSettings {
    static let storageURL = URL.applicationSupportDirectory.appending(path: "settings.json")
    var userPreferences: UserPreferences
    
    init() { userPreferences = AppSettings.load() }
    
    @MainActor static let shared = AppSettings()
    
    func save() throws {
        coreLogger.debug("saving a lot of prefs data...")
        let dir = AppSettings.storageURL.deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            try JSONEncoder().encode(self.userPreferences).write(to: AppSettings.storageURL, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
        } catch { coreLogger.error("something went wrong with saving prefs") }
        coreLogger.debug("saved prefs data")
    }
    
    static func load() -> UserPreferences {
        coreLogger.debug("loading a lot of prefs data...")
        guard let data = try? Data(contentsOf: AppSettings.storageURL) else {
            coreLogger.info("no prefs file, using default")
            return UserPreferences()
        }
        guard let parsedData = try? JSONDecoder().decode(UserPreferences.self, from: data) else {
            coreLogger.error("prefs data was unparsable")
            return UserPreferences()
        }
        coreLogger.debug("loaded prefs data")
        return parsedData
    }
}
