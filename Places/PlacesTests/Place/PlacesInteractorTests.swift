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
        
        XCTAssertEqual(env.presenterSpy.messages, [.loading, .placesError(PlacesInteractor.Error.failedToLoadPlaces)])
    }
    
    func test_didChoosePlace_asksRouterToNavigateToPlace() async {
        let sut = makeSUT()
        let place = Place(name: "any", latitude: 2, longitude: 2)
        env.loaderSpy.stubbedLoadPlacesResult = .success([uniquePlace(), place, uniquePlace()])
        await sut.loadPlaces()
        
        sut.didChoosePlace(withID: place.id)
        
        XCTAssertEqual(env.routerSpy.transitions, [.place(place)])
    }
    
    func test_didCreateCustomCoordines_whenNotValidDoubles_notifyPresenterWithError() {
        let sut = makeSUT()
        let inValidDouble = "non double value"
        let validDouble = "1.0"
        
        sut.didCreateCustomCoordines(latitude: inValidDouble, longitude: validDouble)
        sut.didCreateCustomCoordines(latitude: validDouble, longitude: inValidDouble)
        sut.didCreateCustomCoordines(latitude: inValidDouble, longitude: inValidDouble)
        
        let expectedError = PlacesInteractor.Error.invalidCustomCoordinates
        let expectedResult = PlacesPresenterSpy.Message.customCoordinatesError(expectedError)
        XCTAssertEqual(env.presenterSpy.messages, [expectedResult, expectedResult, expectedResult])
    }
    
    func test_didCreateCustomCoordines_whenCoordinatesAreValid_asksRouterToNavigateToPlaceWithCoordinates() {
        let sut = makeSUT()
        let place = Place(latitude: 22.0, longitude: 12.0)
        
        sut.didCreateCustomCoordines(latitude: "\(place.latitude)", longitude: "\(place.longitude)")
        
        XCTAssertEqual(env.routerSpy.transitions, [.place(place)])
    }
    
    func test_didCreateCustomCoordines_whenCoordinatesAreValid_notifyPresenter() {
        let sut = makeSUT()
        
        sut.didCreateCustomCoordines(latitude: "\(22.0)", longitude: "\(12.0)")
        
        XCTAssertEqual(env.presenterSpy.messages, [.customCoordinatesSuccess])
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
        case placesError(Error)
        case customCoordinatesSuccess
        case customCoordinatesError(Error)
        
        static func == (lhs: PlacesPresenterSpy.Message, rhs: PlacesPresenterSpy.Message) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case let (.finished(placesLHS), .finished(placesRHS)):
                return placesLHS == placesRHS
                
            case let (.placesError(errorLHS as PlacesInteractor.Error), .placesError(errorRHS as PlacesInteractor.Error)):
                return errorLHS == errorRHS
    
            case (.customCoordinatesSuccess, .customCoordinatesSuccess):
                return true
    
            case let (.customCoordinatesError(errorLHS as PlacesInteractor.Error), .customCoordinatesError(errorRHS as PlacesInteractor.Error)):
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
        messages.append(.placesError(error))
    }
    
    func didFinishProcessingCustomCoordinates() {
        messages.append(.customCoordinatesSuccess)
    }
    
    func didFinishProcessingCustomCoordinates(with error: any Error) {
        messages.append(.customCoordinatesError(error))
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

