//
//  URLEncoder.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import Foundation

public struct URLEncoder: PlacesURLEncoder {
    public func encodeWikipediaURL(latitude: Double, longitude: Double, name: String?) -> URL? {
        var nameComponent: String = ""
        
        if let name = name {
            nameComponent = "%2F\(name)"
        }
        
        let encodedURL = "wikipedia://places?WMFArticleURL=https%3A%2F%2Fen.wikipedia.org%2Fwiki\(nameComponent)%3Flatitude%3D\(latitude)%26longitude%3D\(longitude)"
        
        return URL(string: encodedURL)
    }
}
