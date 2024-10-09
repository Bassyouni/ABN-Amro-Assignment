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
    public init(loader: PlacesLoader) {}
    
    public func loadPlaces() async {
        
    }
}
