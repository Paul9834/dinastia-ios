import Foundation

public enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case invalidResponse
    case httpStatus(code: Int, data: Data)
    case decoding(Error)
}
