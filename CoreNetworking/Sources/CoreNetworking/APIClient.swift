import Foundation

public final class APIClient {
    public let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    public init(baseURL: URL, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    public func jsonBody<T: Encodable>(_ value: T, encoder: JSONEncoder = .init()) throws -> Data {
        try encoder.encode(value)
    }

    public func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let (data, response) = try await sendData(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    public func sendData(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        guard let request = makeRequest(endpoint) else {
            throw NetworkError.invalidURL
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            guard (200..<300).contains(http.statusCode) else {
                throw NetworkError.httpStatus(code: http.statusCode, data: data)
            }

            return (data, http)
        } catch let err as NetworkError {
            throw err
        } catch {
            throw NetworkError.transport(error)
        }
    }

    private func makeRequest(_ endpoint: Endpoint) -> URLRequest? {
        var url = baseURL
        let path = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        url = url.appendingPathComponent(path)

        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        guard let finalURL = components.url else { return nil }

        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if endpoint.body != nil, request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
