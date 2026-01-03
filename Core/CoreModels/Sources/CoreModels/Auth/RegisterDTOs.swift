import Foundation


public struct RegisterRequest: Encodable, Sendable {
    public let nombre: String
    public let apellido: String
    public let correo: String
    public let telefono: String
    public let contrasena: String
    public let rolNombre: String

    public init(nombre: String, apellido: String, correo: String, telefono: String, contrasena: String, rolNombre: String) {
        self.nombre = nombre
        self.apellido = apellido
        self.correo = correo
        self.telefono = telefono
        self.contrasena = contrasena
        self.rolNombre = rolNombre
    }
}

 public struct RegisterResponse: Decodable, Sendable {
    public let token: String
    public let usuario: Usuario

    public init(token: String, usuario: Usuario) {
        self.token = token
        self.usuario = usuario
    }
}


public struct Usuario: Decodable, Sendable {
    public let id: Int
    public let nombre: String
    public let apellido: String
    public let correo: String
    public let telefono: String
    public let rol: String

    public init(id: Int, nombre: String, apellido: String, correo: String, telefono: String, rol: String) {
        self.id = id
        self.nombre = nombre
        self.apellido = apellido
        self.correo = correo
        self.telefono = telefono
        self.rol = rol
    }
}
