import Foundation
import NetworkClient
import Alamofire

public final class AlamofireNetworkClient {
    private let session: Session
    private let decoder: JSONDecoder

    public init(
        session: Session = .default,
        decoder: JSONDecoder = AlamofireNetworkClient.default()
    ) {
        self.session = session
        self.decoder = decoder
    }
}

// MARK: - NetworkClient

extension AlamofireNetworkClient: NetworkClient {
    public func getDecodable<T: Decodable>(_ url: URL, as type: T.Type) async throws -> T {
        let request = session
            .request(url)
            .validate(statusCode: 200..<300)

        do {
            return try await request
                .serializingDecodable(T.self, decoder: decoder)
                .value
        } catch let afError as AFError {
            throw afError
        }
    }
}

// MARK: - Private

public extension AlamofireNetworkClient {
    static func `default`() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            let iso = ISO8601DateFormatter()

            iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = iso.date(from: string) {
                return date
            }

            iso.formatOptions = [.withInternetDateTime]
            if let date = iso.date(from: string) {
                return date
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Bad date: \(string)")
        }

        return decoder
    }
}
