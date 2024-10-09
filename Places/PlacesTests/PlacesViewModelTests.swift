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
            PlaceUIData(name: "any name", location: "any location"),
            PlaceUIData(name: "any", location: "any"),
        ]
        
        sut.displayPlaces(places)
        XCTAssertEqual(sut.places, places)
        
        sut.displayPlaces([])
        XCTAssertEqual(sut.places, [])
    }
}

extension PlacesViewModelTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesViewModel {
        let sut = PlacesViewModel()
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
