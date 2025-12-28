import Foundation

public enum Log {
    public static func d(_ message: String) {
        #if DEBUG
        print("🟢 \(message)")
        #endif
    }

    public static func w(_ message: String) {
        #if DEBUG
        print("🟡 \(message)")
        #endif
    }

    public static func e(_ message: String) {
        #if DEBUG
        print("🔴 \(message)")
        #endif
    }
}
