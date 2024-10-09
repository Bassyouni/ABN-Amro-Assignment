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
        view.showLoading(isLoading: true)
    }
}
