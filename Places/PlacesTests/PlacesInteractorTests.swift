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
        let places = [ uniquePlace(name: "any name"), uniquePlace(name: nil)]
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
    
    func test_didChoosePlace_asksRouterToNavigateToPlace() async {
        let sut = makeSUT()
        let place = Place(name: "any", latitude: 2, longitude: 2)
        env.loaderSpy.stubbedLoadPlacesResult = .success([uniquePlace(), place, uniquePlace()])
        await sut.loadPlaces()
        
        sut.didChoosePlace(withID: place.id)
        
        XCTAssertEqual(env.routerSpy.transitions, [.place(place)])
    }
}

extension PlacesInteractorTests {
    private struct Environment {
        let loaderSpy = PlacesLoaderSpy()
        let presenterSpy = PlacesPresenterSpy()
        let routerSpy = RouterSpy()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesInteractor {
        let sut = PlacesInteractor(loader: env.loaderSpy, presenter: env.presenterSpy, router: env.routerSpy)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func uniquePlace(name: String? = nil) -> Place {
        Place(name: name, latitude: Double.random(in: 1...10), longitude: Double.random(in: 1...10))
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

private class RouterSpy: PlacesTranstions {
    private(set) var transitions = [Transitions]()
    
    enum Transitions: Equatable {
        case place(Place)
    }
    
    func navigateTo(place: Place) {
        transitions.append(.place(place))
    }
}

