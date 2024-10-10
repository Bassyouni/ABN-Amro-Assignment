//
//  PlacesPresenter.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public protocol PlacesPresentationLogic {
    func didStartLoadingPlaces()
    func didFinishLoadingPlaces(with places: [Place])
    func didFinishLoadingPlaces(with error: Error)
    func didFinishProcessingCustomCoordinates(with error: Error)
}

public class PlacesPresenter: PlacesPresentationLogic {
    let view: PlacesDisplayLogic
    
    public init(view: PlacesDisplayLogic) {
        self.view = view
    }
    
    public func didStartLoadingPlaces() {
        view.displayLoading(isLoading: true)
        view.displayError(message: nil)
    }
    
    public func didFinishLoadingPlaces(with places: [Place]) {
        view.displayPlaces(places.map { PlaceUIData(
            id: $0.id,
            name: $0.name?.capitalized ?? "Unknown Location",
            location: "(\($0.latitude), \($0.longitude))"
        )})
        view.displayLoading(isLoading: false)
    }
    
    public func didFinishLoadingPlaces(with error: Error) {
        view.displayError(message: "Unable to load places")
        view.displayLoading(isLoading: false)
    }
    
    public func didFinishProcessingCustomCoordinates(with error: any Error) {
        view.displayCustomCoordinatesError(message: "Invalid coordinates")
    }
}
