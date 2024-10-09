//
//  PlacesView.swift
//  Places
//
//  Created by Omar Bassyouni on 04/10/2024.
//

import SwiftUI

struct PlacesView: View {
    
    @ObservedObject var viewModel: PlacesViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.red)
                    }

                    ForEach(viewModel.places) { place in
                        placeCell(place)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Places")
        }
    }

    func placeCell(_ place: PlaceUIData) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(place.name)
                    .font(.headline)
                    .foregroundColor(Color(red: 4/255, green: 106/255, blue: 56/255))
                Spacer()
            }
            HStack {
                Text(place.location)
                    .font(.subheadline)
                    .monospacedDigit()
                Spacer()
            }
        }
    }
}


#Preview("Loading State") {
    let viewModel = PlacesViewModel()
    let PreviewsPresenter = PreviewsPresenter(viewModel, isLoading: true)
    PlacesView(viewModel: viewModel)
}

#Preview("Loaded Places") {
    let viewModel = PlacesViewModel()
    let PreviewsPresenter = PreviewsPresenter(viewModel, places: [
        PlaceUIData(id: UUID(), name: "New York", location: "(40.730610, 4-73.935242)"),
        PlaceUIData(id: UUID(), name: "Amsterdam", location: "(52.377956,  4.897070)")
    ])
    PlacesView(viewModel: viewModel)
}

#Preview("Error") {
    let viewModel = PlacesViewModel()
    let PreviewsPresenter = PreviewsPresenter(viewModel, errorMessage: "Something bad happened, please try again.")
    PlacesView(viewModel: viewModel)
}
private struct PreviewsPresenter {
    init(
        _ view: PlacesDisplayLogic,
        isLoading: Bool = false,
        places: [PlaceUIData] = [],
        errorMessage: String? = nil
    ) {
        view.displayLoading(isLoading: isLoading)
        view.displayPlaces(places)
        view.displayError(message: errorMessage)
    }
}
