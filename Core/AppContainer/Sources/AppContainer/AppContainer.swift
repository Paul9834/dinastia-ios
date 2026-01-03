import Foundation
import CoreNetworking
import CorePersistence

@MainActor
public final class AppContainer {
    @MainActor public static let shared = AppContainer()

    public let apiClient: APIClient
    public let authAPI: AuthAPIProtocol
    public let registerAPI: RegisterApiProtocol
    public let tokenStore: TokenStore
    

    private init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        apiClient = APIClient(baseURL: AppConfig.apiBaseURL, decoder: decoder)
        authAPI = AuthAPI(client: apiClient)
        registerAPI = RegisterAPI(client: apiClient)
        tokenStore = KeychainTokenStore(service: "com.paul9834.dinastia")
    }
}
