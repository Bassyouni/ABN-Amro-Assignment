//
//  PlaceUIData.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public struct PlaceUIData: Identifiable {
    public let id = UUID()
    public let name: String
    public let location: String
}
