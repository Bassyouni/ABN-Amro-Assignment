//
//  PlacesRouterTests.swift
//  Places
//
//  Created by Omar Bassyouni on 09/10/2024.
//

import XCTest
import Places

final class PlacesRouterTests: XCTestCase {
    private let env = Environment()
    
    func test_init_doesNothing() {
        _ = makeSUT()
        
        XCTAssertEqual(env.urlOpnerSpy.receivedURLs, [])
    }
    
    func test_navigateToPlace_whenURLEncoderReturnNil_doesNothing() {
        let sut = makeSUT()
        env.urlEncoderSpy.stubbedURL = nil
        
        sut.navigateTo(place: Place(latitude: 1, longitude: 1))
        
        XCTAssertEqual(env.urlOpnerSpy.receivedURLs, [])
    }
    
    func test_navigateToPlace_whenURLEncoderReturnURL_requestToOpenURL() {
        let sut = makeSUT()
        let url = URL(string: "www.anyURL.com")!
        env.urlEncoderSpy.stubbedURL = url
        
        sut.navigateTo(place: Place(latitude: 1, longitude: 1))
        
        XCTAssertEqual(env.urlOpnerSpy.receivedURLs, [url])
    }
    
    func test_navigateToPlace_passCorrectCoordinatesToURLEncoder() {
        let sut = makeSUT()
        let latitude = 22.0
        let longitude = 33.0
        
        sut.navigateTo(place: Place(latitude: latitude, longitude: longitude))
        
        XCTAssertEqual(env.urlEncoderSpy.receivedLatitudes, [latitude])
        XCTAssertEqual(env.urlEncoderSpy.receivedLongitudes, [longitude])
    }
    
    func test_navigateToPlace_passCorrectNameToURLEncoder() {
        let sut = makeSUT()
        let name = "any name"
        let nilName: String? = nil
        
        sut.navigateTo(place: Place(name: name, latitude: 1, longitude: 1))
        sut.navigateTo(place: Place(name: nilName, latitude: 1, longitude: 1))
        
        XCTAssertEqual(env.urlEncoderSpy.receivedNames, [name, nilName])
    }
}

extension PlacesRouterTests {
    private struct Environment {
        let urlOpnerSpy = URLOpenerSpy()
        let urlEncoderSpy = PlacesURLEncoderSpy()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesRouter {
        let sut = PlacesRouter(urlOpner: env.urlOpnerSpy, urlEncoder: env.urlEncoderSpy)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

private class URLOpenerSpy: URLOpener {
    private(set) var receivedURLs = [URL]()
    
    func open(_ url: URL) {
        receivedURLs.append(url)
    }
}

private class PlacesURLEncoderSpy: PlacesURLEncoder {
    var stubbedURL: URL?
    private var receivedParameters = [(latitude: Double, longitude: Double, name: String?)]()
    
    var receivedLatitudes: [Double] {
        receivedParameters.map { $0.latitude }
    }
    
    var receivedLongitudes: [Double] {
        receivedParameters.map { $0.longitude }
    }
    
    var receivedNames: [String?] {
        receivedParameters.map { $0.name }
    }
    
    func encodeWikipediaURL(latitude: Double, longitude: Double, name: String?) -> URL? {
        receivedParameters.append((latitude: latitude, longitude: longitude, name: name))
        return stubbedURL
    }
}
