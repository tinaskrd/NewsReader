import Foundation

public enum NewsServiceError: Error {
    case network
    case server(statusCode: Int)
    case decoding
    case invalidData
    case service
}
