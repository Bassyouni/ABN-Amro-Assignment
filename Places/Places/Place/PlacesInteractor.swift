//
//  PlacesInteractor.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

protocol PlacesBusinessLogic {
    func loadPlaces() async
    func didChoosePlace(withID id: UUID)
    func didCreateCustomCoordines(latitude: String, longitude: String)
}

public protocol PlacesTranstions {
    func navigateTo(place: Place)
}

public class PlacesInteractor: PlacesBusinessLogic {
    private let loader: PlacesLoader
    private let presenter: PlacesPresentationLogic
    private let router: PlacesTranstions
    private var places = [Place]()
    
    public enum Error: Swift.Error {
        case failedToLoadPlaces
        case invalidCustomCoordinates
    }
    
    public init(loader: PlacesLoader, presenter: PlacesPresentationLogic, router: PlacesTranstions) {
        self.loader = loader
        self.presenter = presenter
        self.router = router
    }
    
    public func loadPlaces() async {
        presenter.didStartLoadingPlaces()
        
        do {
            let places = try await loader.loadPlaces()
            self.places = places
            presenter.didFinishLoadingPlaces(with: places)
        }
        catch {
            presenter.didFinishLoadingPlaces(with: PlacesInteractor.Error.failedToLoadPlaces)
        }
    }
    
    public func didChoosePlace(withID id: UUID) {
        guard let place = places.first(where: { $0.id == id }) else { return }
        
        router.navigateTo(place: place)
    }
    
    public func didCreateCustomCoordines(latitude: String, longitude: String) {
        if let latitude = Double(latitude), let longitude = Double(longitude) {
            router.navigateTo(place: Place(latitude: latitude, longitude: longitude))
            presenter.didFinishProcessingCustomCoordinates()
        } else {
            presenter.didFinishProcessingCustomCoordinates(with: Error.invalidCustomCoordinates)
        }
    }
}
