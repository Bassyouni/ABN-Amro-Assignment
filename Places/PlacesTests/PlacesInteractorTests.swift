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
        let sut = makeSUT()
        
        await sut.loadPlaces()
        
        XCTAssertEqual(env.loaderSpy.loadPlacesCallCount, 0)
    }
}

extension PlacesInteractorTests {
    private struct Environment {
        let loaderSpy = PlacesLoaderSpy()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesInteractor {
        let sut = PlacesInteractor(loader: env.loaderSpy)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

private class PlacesLoaderSpy: PlacesLoader {
    var loadPlacesCallCount: Int = 0
    
    func loadPlaces() async {
        loadPlacesCallCount += 1
    }
}

