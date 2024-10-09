//
//  Place.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public struct Place: Equatable {
    public let id = UUID()
    public let name: String?
    public let latitude: Double
    public let longitude: Double
    
    public init(name: String? = nil, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}
