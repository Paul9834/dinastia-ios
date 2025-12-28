import Foundation

public enum KeychainError: Error, Sendable, Equatable {
    case unexpectedData
    case unhandledStatus(OSStatus)
}
