//
//  PlacesRouter.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import UIKit

public protocol URLOpener {
    func open(_ url: URL)
}

public protocol PlacesURLEncoder {
    func encodeWikipediaURL(latitude: Double, longitude: Double, name: String?) -> URL?
}

public final class PlacesRouter: PlacesTranstions {
    private let urlOpner: URLOpener
    private let urlEncoder: PlacesURLEncoder
    
    public init(urlOpner: URLOpener, urlEncoder: PlacesURLEncoder) {
        self.urlOpner = urlOpner
        self.urlEncoder = urlEncoder
    }
    
    public func navigateTo(place: Place) {
        let url = urlEncoder.encodeWikipediaURL(
            latitude: place.latitude,
            longitude: place.longitude,
            name: place.name
        )
        
        guard let url else { return }
        
        urlOpner.open(url)
    }
}

