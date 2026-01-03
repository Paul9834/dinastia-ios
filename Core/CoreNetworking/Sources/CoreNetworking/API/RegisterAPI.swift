import Foundation
import CoreModels


public protocol RegisterApiProtocol: Sendable {
    // // Networking: no amarrarlo al MainActor
    func register(_ request: RegisterRequest) async throws -> RegisterResponse
}


public struct RegisterAPI: RegisterApiProtocol, Sendable {
    // // Cliente HTTP reutilizable
    private let client: APIClient

    public init(client: APIClient) {
        self.client = client
    }

    public func register(_ request: RegisterRequest) async throws -> RegisterResponse {
        // // POST http://<baseURL>/auth/login
        try await client.request(
            Endpoint(path: "usuarios/registro", method: .post),
            body: request,
            as: RegisterResponse.self
        )
    }
}
