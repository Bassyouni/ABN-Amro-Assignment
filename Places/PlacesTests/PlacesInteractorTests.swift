//
//  PlacesInteractorTests.swift
//  PlacesTests
//
//  Created by Omar Bassyouni on 04/10/2024.
//

import XCTest
import Places

final class PlacesInteractorTests: XCTestCase {
    private let env = Environment()
    
    func test_init_doesLoadPlaces() async {
        _ = makeSUT()
    
        XCTAssertEqual(env.loaderSpy.loadPlacesCallCount, 0)
    }
    
    func test_loadPlaces_calledTwice_requestsToLoadPlacesTwice() async {
        let sut = makeSUT()
        
        await sut.loadPlaces()
        await sut.loadPlaces()
        
        XCTAssertEqual(env.loaderSpy.loadPlacesCallCount, 2)
    }
    
    func test_loadPlaces_onLoadingPlacesSuccess_notifyPresenterWithPlaces() async {
        let sut = makeSUT()
        let places = [
            Place(name: "any name", latitude: 1, longitude: 1),
            .init(name: nil, latitude: 2, longitude: 2)
            
        ]
        env.loaderSpy.stubbedLoadPlacesResult = places
        
        await sut.loadPlaces()
        
        XCTAssertEqual(env.presenterSpy.messages, [.loading, .finished(places)])
    }
}

extension PlacesInteractorTests {
    private struct Environment {
        let loaderSpy = PlacesLoaderSpy()
        let presenterSpy = PlacesPresenterSpy()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesInteractor {
        let sut = PlacesInteractor(loader: env.loaderSpy, presenter: env.presenterSpy)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

private class PlacesLoaderSpy: PlacesLoader {
    private(set) var loadPlacesCallCount: Int = 0
    var stubbedLoadPlacesResult = [Place]()
    
    func loadPlaces() async -> [Place] {
        loadPlacesCallCount += 1
        return stubbedLoadPlacesResult
    }
}

private class PlacesPresenterSpy: PlacesPresentationLogic {
    private(set) var messages = [Message]()
    
    enum Message: Equatable {
        case loading
        case finished([Place])
    }
    
    func didStartLoadingPlaces() {
        messages.append(.loading)
    }
    
    func didFinishLoadingPlaces(with places: [Places.Place]) {
        messages.append(.finished(places))
    }
}

