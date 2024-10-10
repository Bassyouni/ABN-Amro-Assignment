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
