// SendPayload.swift
import Foundation

// it's a class because we want to disable memberwise copy semantics
// (the capability here is unique per-file object)
final class FileStruct {
    let url: URL
    let keys: Set<URLResourceKey> = [.fileSizeKey, .contentTypeKey,
        .creationDateKey, .contentModificationDateKey]
    let name: String
    let values: URLResourceValues?
    let size: Int?
    let uti: String?
    let error: Error?
    
    init(_ url: URL) {
        let _ = url.startAccessingSecurityScopedResource()
        self.url = url
        self.name = url.lastPathComponent
        do {
            self.values = try url.resourceValues(forKeys: keys)
            self.size = values?.fileSize
            self.uti = values?.contentType?.preferredMIMEType
            self.error = nil
        } catch {
            self.values = nil
            self.size = nil
            self.uti = nil
            self.error = error
            print(self.error.debugDescription)
        }
    }
    
    deinit { self.url.stopAccessingSecurityScopedResource() }
}

enum SendPayload: Identifiable, Hashable {
    case success([URL])
    case failure(String)
    
    var id: String {
        switch self {
        case .success(let urls): return urls.map(\.absoluteString).joined(separator: ",")
        case .failure(let error): return error
        }
    }
}

// cannot be @MainActor because we need mutation here later on
// that must be thread-safe for up2k to work right.
@Observable
final class SendManager {
    let payload: SendPayload
    let files: [FileStruct]
    let totalSize: Int
    var hasErrors: Bool { files.contains { $0.error != nil } }
    
    init(_ payload: SendPayload) {
        self.payload = payload
        self.files = {
            guard case .success(let urls) = payload else { return [] }
            return urls.map(FileStruct.init)
        }()
        self.totalSize = files.compactMap(\.size).reduce(0, +)
    }
}

