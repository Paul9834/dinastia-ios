import Foundation

public final class APIClient: @unchecked Sendable {
    // URL base del backend (en tu caso incluye /api)
    public let baseURL: URL

    // Sesión HTTP usada para hacer requests
    private let session: URLSession

    // Decoder para mapear JSON -> modelos Decodable
    private let decoder: JSONDecoder

    // Inicializador del cliente
    public init(baseURL: URL, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    // Convierte un objeto Encodable a JSON Data
    public func jsonBody<T: Encodable>(_ value: T, encoder: JSONEncoder = .init()) throws -> Data {
        try encoder.encode(value)
    }

    // Envia un endpoint ya armado y decodifica la respuesta
    public func send<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let (data, _) = try await sendData(endpoint)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }

    // Envia un endpoint y retorna Data + HTTPURLResponse
    public func sendData(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        // Construimos el URLRequest final
        guard let request = makeRequest(endpoint) else { throw NetworkError.invalidURL }

        do {
            // Ejecutamos la petición
            let (data, response) = try await session.data(for: request)

            // Validamos respuesta HTTP
            guard let http = response as? HTTPURLResponse else { throw NetworkError.invalidResponse }

            // Validamos status code
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

    // Método de conveniencia: construye el endpoint con body JSON y decodifica la respuesta
    public func request<Response: Decodable, Body: Encodable>(
        _ endpoint: Endpoint,
        body: Body,
        as type: Response.Type = Response.self
    ) async throws -> Response {
        // Convertimos el body a JSON Data
        let bodyData = try jsonBody(body)

        // Creamos un endpoint nuevo copiando el original y metiendo el body
        // Nota: el orden de parámetros debe respetar tu initializer real de Endpoint
        let endpointWithBody = Endpoint(
            path: endpoint.path,
            method: endpoint.method,
            queryItems: endpoint.queryItems,
            headers: endpoint.headers.merging(["Content-Type": "application/json"]) { current, _ in current },
            body: bodyData
        )

        // Reusamos send(...) para decodificar
        return try await send(endpointWithBody, as: type)
    }

    // Construye el URLRequest final con path, queryItems, headers y body
    private func makeRequest(_ endpoint: Endpoint) -> URLRequest? {
        // Armamos la URL final: baseURL + path
        var url = baseURL
        let path = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        url = url.appendingPathComponent(path)

        // Agregamos query items (si existen)
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        if !endpoint.queryItems.isEmpty { components.queryItems = endpoint.queryItems }
        guard let finalURL = components.url else { return nil }

        // Creamos el request
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        // Agregamos headers
        endpoint.headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Si hay body y no se especificó Content-Type, lo ponemos en JSON
        if endpoint.body != nil, request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
}
