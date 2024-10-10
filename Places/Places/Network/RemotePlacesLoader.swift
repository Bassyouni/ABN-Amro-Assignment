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
    
    public init(url: URL, httpClient: HTTPClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func loadPlaces() async throws -> [Place] {
        return []
    }
}
