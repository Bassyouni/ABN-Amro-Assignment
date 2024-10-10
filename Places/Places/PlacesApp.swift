//
//  PlacesApp.swift
//  Places
//
//  Created by Omar Bassyouni on 04/10/2024.
//

import SwiftUI

@main
struct PlacesApp: App {
    var body: some Scene {
        WindowGroup {
            let url = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
            let client = URLSessionHTTPClient(session: URLSession.shared)
            let placesLoader = RemotePlacesLoader(url: url, httpClient: client)
            let router = PlacesRouter(urlOpner: UIApplication.shared, urlEncoder: URLEncoder())
            let viewModel = PlacesViewModel()
            let presenter = PlacesPresenter(view: MainQueueDispatchDecorator(decoratee: viewModel))
            let interactor = PlacesInteractor(loader: placesLoader, presenter: presenter, router: router)
            
            PlacesView(interactor: interactor, viewModel: viewModel)
        }
    }
}

// Placeholder and to test if the logic UI changes is made on the main thread
private class BackgroundQueuePlacesLoader: PlacesLoader {
    
    func loadPlaces() async throws -> [Place] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
        
                let places: [Place] = [
                    Place(name: "Paris", latitude: 48.8566, longitude: 2.3522),
                    Place(name: "London", latitude: 51.5074, longitude: -0.1278)
                ]
                
                continuation.resume(returning: places)
            }
        }
    }
}
