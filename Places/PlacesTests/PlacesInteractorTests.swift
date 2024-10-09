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
            Place(name: nil, latitude: 2, longitude: 2)
        ]
        env.loaderSpy.stubbedLoadPlacesResult = .success(places)
        
        await sut.loadPlaces()
        
        XCTAssertEqual(env.presenterSpy.messages, [.loading, .finished(places)])
    }
    
    func test_loadPlaces_onLoadingPlacesFailure_notifyPresenterWithError() async {
        let sut = makeSUT()
        env.loaderSpy.stubbedLoadPlacesResult = .failure(NSError(domain: "Tests", code: 1))
        
        await sut.loadPlaces()
        
        XCTAssertEqual(env.presenterSpy.messages, [.loading, .error(PlacesInteractor.Error.failedToLoadPlaces)])
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
    var stubbedLoadPlacesResult: Result<[Place], Error> = .failure(NSError(domain: "Any", code: 0))
    
    func loadPlaces() async throws -> [Place] {
        loadPlacesCallCount += 1
        return try stubbedLoadPlacesResult.get()
    }
}

private class PlacesPresenterSpy: PlacesPresentationLogic {
    private(set) var messages = [Message]()
    
    enum Message: Equatable {
        case loading
        case finished([Place])
        case error(Error)
        
        static func == (lhs: PlacesPresenterSpy.Message, rhs: PlacesPresenterSpy.Message) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case let (.finished(placesLHS), .finished(placesRHS)):
                return placesLHS == placesRHS
                
            case let (.error(errorLHS as PlacesInteractor.Error), .error(errorRHS as PlacesInteractor.Error)):
                return errorLHS == errorRHS
                
            default:
                return false
            }
        }
    }
    
    func didStartLoadingPlaces() {
        messages.append(.loading)
    }
    
    func didFinishLoadingPlaces(with places: [Places.Place]) {
        messages.append(.finished(places))
    }
    
    func didFinishLoadingPlaces(with error: Error) {
        messages.append(.error(error))
    }
}

