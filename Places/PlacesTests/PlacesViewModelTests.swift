//
//  PlacesViewModelTests.swift
//  PlacesTests
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import XCTest
import Places

@MainActor
final class PlacesViewModelTests: XCTestCase {
    func test_init_isLoadingIsFalseByDefault() {
        XCTAssertEqual(makeSUT().isLoading, false)
    }
    
    func test_init_placesIsEmptyByDefault() {
        XCTAssertEqual(makeSUT().places, [])
    }
    
    func test_init_errorMessageIsNilByDefault() {
        XCTAssertEqual(makeSUT().errorMessage, nil)
    }
    
    func test_displayLoading_setsIsLoading() {
        let sut = makeSUT()
        
        sut.displayLoading(isLoading: true)
        XCTAssertEqual(sut.isLoading, true)
        
        sut.displayLoading(isLoading: false)
        XCTAssertEqual(sut.isLoading, false)
    }
    
    func test_displayPlaces_setsDataToPlaces() {
        let sut = makeSUT()
        let places = [
            PlaceUIData(id: UUID(), name: "any name", location: "any location"),
            PlaceUIData(id: UUID(),name: "any", location: "any"),
        ]
        
        sut.displayPlaces(places)
        XCTAssertEqual(sut.places, places)
        
        sut.displayPlaces([])
        XCTAssertEqual(sut.places, [])
    }
    
    func test_displayError_setsErrorMessage() {
        let sut = makeSUT()
        let message = "any error"
        
        sut.displayError(message: message)
        XCTAssertEqual(sut.errorMessage, message)
        
        sut.displayError(message: nil)
        XCTAssertEqual(sut.errorMessage, nil)
    }
    
    func test_displayCustomCoordinatesError_setCustomCoordinatesErrorMessageWithMessage() {
        let sut = makeSUT()
        let message = "any error"
        
        sut.displayCustomCoordinatesError(message: message)
        
        XCTAssertEqual(sut.customCoordinatesErrorMessage, message)
    }
    
    func test_customCoordinatesErrorMessage_whenEitherLatitudeOrLongitudeChange_removeErrorMessage() {
        let sut = makeSUT()
        
        sut.displayCustomCoordinatesError(message: "any")
        sut.customLatitude = "1"
        XCTAssertEqual(sut.customCoordinatesErrorMessage, nil)
        
        sut.displayCustomCoordinatesError(message: "any")
        sut.customLongitude = sut.customLongitude + "2"
        XCTAssertEqual(sut.customCoordinatesErrorMessage, nil)
    }
}

extension PlacesViewModelTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesViewModel {
        let sut = PlacesViewModel()
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
