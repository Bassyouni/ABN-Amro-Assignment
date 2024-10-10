//
//  CLLocationCoordinatesValidator.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import CoreLocation

final class CLLocationCoordinatesValidator: CoordinatesValidator {
    func isValid(latitude: Double, longitude: Double) -> Bool {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return CLLocationCoordinate2DIsValid(coordinate)
    }
}
