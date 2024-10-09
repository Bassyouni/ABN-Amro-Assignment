//
//  PlacesInteractor.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

protocol PlacesBusinessLogic {
    func loadPlaces() async
}

public class PlacesInteractor: PlacesBusinessLogic {
    private let loader: PlacesLoader
    private let presenter: PlacesPresentationLogic
    
    public enum Error: Swift.Error {
        case failedToLoadPlaces
    }
    
    public init(loader: PlacesLoader, presenter: PlacesPresentationLogic) {
        self.loader = loader
        self.presenter = presenter
    }
    
    public func loadPlaces() async {
        presenter.didStartLoadingPlaces()
        
        do {
            let places = try await loader.loadPlaces()
            presenter.didFinishLoadingPlaces(with: places)
        }
        catch {
            presenter.didFinishLoadingPlaces(with: PlacesInteractor.Error.failedToLoadPlaces)
        }
    }
}
