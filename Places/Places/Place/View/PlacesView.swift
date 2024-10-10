//
//  PlacesView.swift
//  Places
//
//  Created by Omar Bassyouni on 04/10/2024.
//

import SwiftUI

struct PlacesView: View {
    
    let interactor: PlacesBusinessLogic
    
    @ObservedObject var viewModel: PlacesViewModel
    @State private var selectedSegment: Segments = .list
    
    private let customGreyColor = Color(red: 0, green: 58/255, blue: 83/255)
    private let customGreenColor = Color(red: 4/255, green: 106/255, blue: 56/255)
    
    enum Segments {
        case list
        case custom
    }
    
    var body: some View {
        NavigationView {
            VStack {
                segmentsView
                
                switch selectedSegment {
                case .list:
                    listView
                case .custom:
                    customCoordinatesView
                }
                
                Spacer()
            }
            .navigationTitle("Places")
        }
        .task {
            await interactor.loadPlaces()
        }
    }
    
    var segmentsView: some View {
        Picker("", selection: $selectedSegment) {
            Text("List")
                .tag(Segments.list)
                .accessibilityLabel("Places List view")
            
            Text("Custom")
                .tag(Segments.custom)
                .accessibilityLabel("Custom coordinates view")
        }
        .pickerStyle(.segmented)
        .padding()
    }
    
    @ViewBuilder
    var listView: some View {
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
    }

    func placeCell(_ place: PlaceUIData) -> some View {
        Button {
            interactor.didChoosePlace(withID: place.id)
        } label: {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(place.name)
                        .font(.headline)
                        .foregroundColor(customGreenColor)
                        
                    Spacer()
                }
                HStack {
                    Text(place.location)
                        .font(.subheadline)
                        .monospacedDigit()
                        .foregroundStyle(customGreyColor)
                    Spacer()
                }
            }
        }
        .accessibilityLabel(place.name)
    }
    
    @ViewBuilder
    var customCoordinatesView: some View {
        TextField("Enter Latitude", text: $viewModel.customLatitude)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numbersAndPunctuation)
            .padding()
        
        TextField("Enter Longitude", text: $viewModel.customLongitude)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(.numbersAndPunctuation)
            .padding()
        
        if let errorMessage = viewModel.customCoordinatesErrorMessage {
            Text(errorMessage)
                .multilineTextAlignment(.leading)
                .foregroundColor(.red)
        }
        
        Button {
            interactor.didCreateCustomCoordines(
                latitude: viewModel.customLatitude,
                longitude: viewModel.customLongitude
            )
        } label: {
            Text("Go to Coordinates")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(customGreenColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
}

#Preview("Loading State") {
    let viewModel = PlacesViewModel()
    let PreviewsPresenter = PreviewsPresenter(viewModel, isLoading: true)
    PlacesView(interactor: NullInteractor(), viewModel: viewModel)
}

#Preview("Loaded Places") {
    let viewModel = PlacesViewModel()
    let PreviewsPresenter = PreviewsPresenter(viewModel, places: [
        PlaceUIData(id: UUID(), name: "New York", location: "(40.730610, 4-73.935242)"),
        PlaceUIData(id: UUID(), name: "Amsterdam", location: "(52.377956,  4.897070)")
    ])
    PlacesView(interactor: NullInteractor(), viewModel: viewModel)
}

#Preview("Error") {
    let viewModel = PlacesViewModel()
    let PreviewsPresenter = PreviewsPresenter(viewModel, errorMessage: "Something bad happened, please try again.")
    PlacesView(interactor: NullInteractor(), viewModel: viewModel)
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

private struct NullInteractor: PlacesBusinessLogic {
    func loadPlaces() async {}
    func didChoosePlace(withID id: UUID) {}
    func didCreateCustomCoordines(latitude: String, longitude: String) {}
}
