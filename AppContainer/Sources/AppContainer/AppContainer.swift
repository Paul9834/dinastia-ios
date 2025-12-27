import Foundation
import CoreNetworking

public final class AppContainer {
    public static let shared = AppContainer()

    public let apiClient: APIClient

    private init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        apiClient = APIClient(baseURL: AppConfig.apiBaseURL, decoder: decoder)
    }
}
