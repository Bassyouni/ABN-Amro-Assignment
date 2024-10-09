//
//  PlacesInteractor.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public struct Place: Equatable {
    let name: String?
    let latitude: Double
    let longitude: Double
    
    public init(name: String? = nil, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

protocol PlacesBusinessLogic {
    
}

public protocol PlacesLoader {
    func loadPlaces() async -> [Place]
}

public class PlacesInteractor {
    private let loader: PlacesLoader
    private let presenter: PlacesPresentationLogic
    
    public init(loader: PlacesLoader, presenter: PlacesPresentationLogic) {
        self.loader = loader
        self.presenter = presenter
    }
    
    public func loadPlaces() async {
        presenter.didStartLoadingPlaces()
        let places = await loader.loadPlaces()
        presenter.didFinishLoadingPlaces(with: places)
    }
}
