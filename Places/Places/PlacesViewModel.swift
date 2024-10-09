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

public class PlacesViewModel: ObservableObject, PlacesDisplayLogic {
    
    @Published public private(set) var isLoading = false
    @Published public private(set) var places = [PlaceUIData]()
    @Published public private(set) var errorMessage: String?
    
    public init() {}
    
    public func displayLoading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    public func displayPlaces(_ places: [PlaceUIData]) {
        self.places = places
    }
    
    public func displayError(message: String?) {
        self.errorMessage = message
    }
}
