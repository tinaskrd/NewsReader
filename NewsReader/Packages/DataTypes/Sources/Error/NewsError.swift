//
//  NewsError.swift
//  DataTypes
//

import Foundation

public enum NewsError: Error {
    case network
    case server(statusCode: Int)
    case decoding
    case invalidData
    case service
}
