//
//  PlacesViewModel.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Combine
import Foundation

public protocol PlacesDisplayLogic {
    func displayLoading(isLoading: Bool)
    func displayPlaces(_ places: [PlaceUIData])
    func displayError(message: String?)
}

@MainActor
public class PlacesViewModel: ObservableObject {
    
    @Published public var isLoading = false
    
    public init() {}
}
