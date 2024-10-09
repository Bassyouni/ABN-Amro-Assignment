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
}

public class PlacesPresenter {
    let view: PlacesDisplayLogic
    
    public init(view: PlacesDisplayLogic) {
        self.view = view
    }
    
    public func didStartLoadingPlaces() {
        view.displayLoading(isLoading: true)
    }
    
    public func didFinishLoadingPlaces(with places: [Place]) {
        view.displayPlaces(places.map { PlaceUIData(
            name: $0.name?.capitalized ?? "Unknown Location",
            location: "(\($0.latitude), \($0.longitude))"
        )})
        view.displayLoading(isLoading: false)
    }
}
