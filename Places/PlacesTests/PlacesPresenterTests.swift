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
    
    enum Message: Equatable {
        case showLoading
        case hideLoading
        case showPlaces(PlaceUIData)
    }
    
    func showLoading(isLoading: Bool) {
        messages.append(isLoading ? .showLoading : .hideLoading)
    }
    
    func showPlaces(_ places: PlaceUIData) {
        messages.append(.showPlaces(places))
    }
}
