//
//  URLEncoderTests.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import XCTest
@testable import Places

class URLEncoderTests: XCTestCase {
    
    func test_encodeWikipediaURL_withCoordinatesAndNoName_returnsCorrectlyEncodedURL() {
        let sut = makeSUT()
        let latitude = -33.8688
        let longitude = 151.2093
        
        let encodedURL = sut.encodeWikipediaURL(latitude: latitude, longitude: longitude, name: nil)
        
        let expectedURLString = "wikipedia://places?WMFArticleURL=https%3A%2F%2Fen.wikipedia.org%2Fwiki%3Flatitude%3D-33.8688%26longitude%3D151.2093"
        XCTAssertEqual(encodedURL?.absoluteString, expectedURLString)
    }
    
    func test_encodeWikipediaURL_withCoordinatesAndName_returnsCorrectlyEncodedURL() {
        let sut = makeSUT()
        let name = "Amsterdam"
        
        let encodedURL = sut.encodeWikipediaURL(latitude: 1, longitude: 1.2, name: name)
        
        let expectedURLString = "wikipedia://places?WMFArticleURL=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FAmsterdam%3Flatitude%3D1.0%26longitude%3D1.2"
        XCTAssertEqual(encodedURL?.absoluteString, expectedURLString)
    }
}

extension URLEncoderTests {
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLEncoder {
        return URLEncoder()
    }
}
