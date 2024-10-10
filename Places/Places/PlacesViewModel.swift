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
    func displayCustomCoordinatesError(message: String)
}

public class PlacesViewModel: ObservableObject, PlacesDisplayLogic {
    
    @Published public private(set) var isLoading = false
    @Published public private(set) var places = [PlaceUIData]()
    @Published public private(set) var errorMessage: String?
    @Published public private(set) var customCoordinatesErrorMessage: String?
    @Published public var customLatitude: String = ""
    @Published public var customLongitude: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        
        Combine.Publishers
            .Merge($customLatitude, $customLongitude)
            .dropFirst(2)
            .sink { [weak self] _ in
                self?.customCoordinatesErrorMessage = nil
            }
            .store(in: &cancellables)
    }
    
    public func displayLoading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    public func displayPlaces(_ places: [PlaceUIData]) {
        self.places = places
    }
    
    public func displayError(message: String?) {
        self.errorMessage = message
    }
    
    public func displayCustomCoordinatesError(message: String) {
        customCoordinatesErrorMessage = message
    }
}
