// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol NetworkClient {
    func getDecodable<T: Decodable>(_ url: URL, as type: T.Type) async throws -> T
}
