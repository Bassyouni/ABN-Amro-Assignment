//
//  PlacesMapper.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import Foundation

final class PlacesMapper {
    private struct Root: Decodable {
        let locations: [PlaceDTO]
        
        var places: [Place] {
            locations.map { $0.place }
        }
    }

    private struct PlaceDTO: Decodable {
        let name: String?
        let lat: Double
        let long: Double
        
        var place: Place {
            Place(name: name, latitude: lat, longitude: long)
        }
    }
    
    func map(data: Data) -> Result<[Place], Error> {
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemotePlacesLoader.Error.invalidData)
        }
        
        return .success(root.places)
    }
}
