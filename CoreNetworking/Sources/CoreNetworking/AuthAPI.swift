import Foundation
import CoreModels

public protocol AuthAPIProtocol {
    func login(_ request: LoginRequest) async throws -> LoginResponse
}

public struct AuthAPI: AuthAPIProtocol {
    private let client: APIClient

    public init(client: APIClient) {
        self.client = client
    }

    public func login(_ request: LoginRequest) async throws -> LoginResponse {
        try await client.request(Endpoint(path: "auth/login", method: .post), body: request)
    }
}
