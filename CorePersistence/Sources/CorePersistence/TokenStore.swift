import Foundation

public protocol TokenStore: Sendable {
    func save(_ token: String) throws
    func load() throws -> String?
    func clear() throws
}
