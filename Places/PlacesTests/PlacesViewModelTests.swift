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
    
    func test_displayLoading_setsIsLoading() {
        let sut = makeSUT()
        
        sut.displayLoading(isLoading: true)
        XCTAssertEqual(sut.isLoading, true)
        
        sut.displayLoading(isLoading: false)
        XCTAssertEqual(sut.isLoading, false)
    }
}

extension PlacesViewModelTests {
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesViewModel {
        let sut = PlacesViewModel()
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
