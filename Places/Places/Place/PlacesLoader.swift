//
//  PlacesLoader.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

public protocol PlacesLoader {
    func loadPlaces() async throws -> [Place]
}
