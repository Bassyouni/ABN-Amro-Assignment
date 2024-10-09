//
//  PlacesPresenterTests.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import XCTest
import Places

final class PlacesPresenterTests: XCTestCase {
    private let env = Environment()
    
    func test_init_doesNotSendAnyRequestsToViewModel() async {
        _ = makeSUT()
    
        XCTAssertEqual(env.viewModelSpy.messages, [])
    }
    
    func test_didStartLoadingPlaces_requestsViewToShowLoadingAndHideError() {
        let sut = makeSUT()
        
        sut.didStartLoadingPlaces()
        
        XCTAssertEqual(env.viewModelSpy.messages, [.showLoading, .hideError])
    }
    
    func test_didFinishLoadingPlaces_requestsViewToShowPlacesAndThenHideLoading() {
        let sut = makeSUT()
        
        sut.didFinishLoadingPlaces(with: [Place(name: "", latitude: 1.2, longitude: 1)])
        
        XCTAssertEqual(env.viewModelSpy.messages, [.showPlaces, .hideLoading])
    }
    
    func test_didFinishLoadingPlaces_whenNameInPlaceIsNilSetItToDefaultValue() {
        let sut = makeSUT()
        
        sut.didFinishLoadingPlaces(with: [Place(name: nil, latitude: 1, longitude: 1)])
        
        XCTAssertEqual(env.viewModelSpy.receivedPlaces().first?.name, "Unknown Location")
    }
    
    func test_didFinishLoadingPlaces_whenNameIsNotCapitalziedSetsNameToBeCapitalized() {
        let sut = makeSUT()
        let places = [
            Place(name: "new york", latitude: 1, longitude: 1),
            Place(name: "berlin", latitude: 1, longitude: 1)
        ]
        
        sut.didFinishLoadingPlaces(with: places)
        
        XCTAssertEqual(env.viewModelSpy.receivedPlaces().first?.name, "New York")
        XCTAssertEqual(env.viewModelSpy.receivedPlaces().last?.name, "Berlin")
    }
    
    func test_didFinishLoadingPlaces_changesLocationFromDoubleToFormattedString() {
        let sut = makeSUT()
        let places = [
            Place(name: "", latitude: 1.1, longitude: 1),
            Place(name: "", latitude: 2, longitude: 2.2)
        ]
        
        sut.didFinishLoadingPlaces(with: places)
        
        XCTAssertEqual(env.viewModelSpy.receivedPlaces().first?.location, "(1.1, 1.0)")
        XCTAssertEqual(env.viewModelSpy.receivedPlaces().last?.location, "(2.0, 2.2)")
    }
}

extension PlacesPresenterTests {
    private struct Environment {
        let viewModelSpy = PlacesViewModelSpy()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesPresenter {
        let sut = PlacesPresenter(view: env.viewModelSpy)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

private class PlacesViewModelSpy: PlacesDisplayLogic {
    private(set) var messages = [Message]()
    private var receivedPleaces = [[PlaceUIData]]()
    
    enum Message: Equatable {
        case showLoading
        case hideLoading
        case showPlaces
        case showError(String)
        case hideError
    }
    
    func displayLoading(isLoading: Bool) {
        messages.append(isLoading ? .showLoading : .hideLoading)
    }
    
    func displayPlaces(_ places: [PlaceUIData]) {
        messages.append(.showPlaces)
        receivedPleaces.append(places)
    }
    
    func receivedPlaces(at index: Int = 0) -> [PlaceUIData] {
        receivedPleaces[index]
    }
    
    func displayError(message: String?) {
        if let message = message {
            messages.append(.showError(message))
        } else {
            messages.append(.hideError)
        }
    }
}
