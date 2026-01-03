import Foundation
import CoreModels

public protocol AuthAPIProtocol: Sendable {
    // // Networking: no amarrarlo al MainActor
    func login(_ request: LoginRequest) async throws -> LoginResponse
}

public struct AuthAPI: AuthAPIProtocol, Sendable {
    // // Cliente HTTP reutilizable
    private let client: APIClient

    public init(client: APIClient) {
        self.client = client
    }

    public func login(_ request: LoginRequest) async throws -> LoginResponse {
        // // POST http://<baseURL>/auth/login
        try await client.request(
            Endpoint(path: "auth/login", method: .post),
            body: request,
            as: LoginResponse.self
        )
    }
}
