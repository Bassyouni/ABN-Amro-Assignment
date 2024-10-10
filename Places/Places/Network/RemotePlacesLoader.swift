//
//  RemotePlacesLoader.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import Foundation

public final class RemotePlacesLoader: PlacesLoader {
    
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
        guard let data = try? await httpClient.get(url: url) else {
            throw Error.networkError
        }
        
        return try PlacesMapper().map(data: data).get()
    }
}
