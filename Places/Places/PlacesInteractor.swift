//
//  PlacesInteractor.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

protocol PlacesBusinessLogic {
    
}

public protocol PlacesLoader {
    func loadPlaces() async
}

public class PlacesInteractor {
    private let loader: PlacesLoader
    
    public init(loader: PlacesLoader) {
        self.loader = loader
    }
    
    public func loadPlaces() async {
        await loader.loadPlaces()
    }
}
