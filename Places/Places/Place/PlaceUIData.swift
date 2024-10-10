//
//  PlaceUIData.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public struct PlaceUIData: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let location: String
    
    public init(id: UUID, name: String, location: String) {
        self.id = id
        self.name = name
        self.location = location
    }
}
