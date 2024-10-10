//
//  MainQueueDispatchDecorator.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T

    init(decoratee: T) {
        self.decoratee = decoratee
    }

    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }

        completion()
    }
}

extension MainQueueDispatchDecorator: PlacesDisplayLogic where T == PlacesDisplayLogic {
    func displayLoading(isLoading: Bool) {
        dispatch { [weak self] in
            self?.decoratee.displayLoading(isLoading: isLoading)
        }
    }
    
    func displayPlaces(_ places: [PlaceUIData]) {
        dispatch { [weak self] in
            self?.decoratee.displayPlaces(places)
        }
    }
    
    func displayError(message: String?) {
        dispatch { [weak self] in
            self?.decoratee.displayError(message: message)
        }
    }
    
    func displayCustomCoordinatesError(message: String) {
        dispatch { [weak self] in
            self?.decoratee.displayCustomCoordinatesError(message: message)
        }
    }
}
