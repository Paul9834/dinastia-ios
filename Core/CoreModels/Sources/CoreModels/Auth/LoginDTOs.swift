import Foundation

public struct LoginRequest: Encodable, Sendable {
    public let correo: String
    public let contrasena: String

    public init(correo: String, contrasena: String) {
        self.correo = correo
        self.contrasena = contrasena
    }
}

public struct LoginResponse: Decodable, Sendable {
    public let token: String

    public init(token: String) {
        self.token = token
    }
}
