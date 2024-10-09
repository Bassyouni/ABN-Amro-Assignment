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
            PlacesView(viewModel: PlacesViewModel())
        }
    }
}
