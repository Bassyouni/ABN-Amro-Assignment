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
            let data = try await httpClient.get(url: url)
            return try map(data: data).get()
        } catch Error.invalidData {
            throw Error.invalidData
        } catch {
            throw Error.networkError
        }
    }
    
    private func map(data: Data) -> Result<[Place], Error> {
        let root = try? JSONDecoder().decode(Root.self, from: data)
        
        guard let root = root else { return .failure(Error.invalidData) }
        
        let places = root.locations.map { Place(name: $0.name, latitude: $0.lat, longitude: $0.long) }
        return .success(places)
    }
}

private struct Root: Decodable {
    let locations: [PlaceDTO]
}

private struct PlaceDTO: Decodable {
    let name: String?
    let lat: Double
    let long: Double
}

