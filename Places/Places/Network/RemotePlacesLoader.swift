//
//  RemotePlacesLoader.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import Foundation

public final class RemotePlacesLoader {
    
    private let url: URL
    private let httpClient: HTTPClient
    
    public enum Error: Swift.Error {
        case networkError
        case invalidData
    }
    
    public init(url: URL, httpClient: HTTPClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func loadPlaces() async throws -> [Place] {
        do {
            _ = try await httpClient.get(url: url)
            throw Error.invalidData
        } catch Error.invalidData {
            throw Error.invalidData
        } catch {
            throw Error.networkError
        }
    }
}
