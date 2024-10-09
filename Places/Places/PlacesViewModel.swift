//
//  PlacesViewModel.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public protocol PlacesDisplayLogic {
    func displayLoading(isLoading: Bool)
    func displayPlaces(_ places: [PlaceUIData])
    func displayError(message: String?)
}

public class PlacesViewModel {
    
}
