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
}

extension PlacesRouterTests {
    private struct Environment {
        let urlOpnerSpy = URLOpenerSpy()
        let urlEncoderStub = PlacesURLEncoderStub()
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlacesRouter {
        let sut = PlacesRouter(urlOpner: env.urlOpnerSpy, urlEncoder: env.urlEncoderStub)
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

private struct PlacesURLEncoderStub: PlacesURLEncoder {
    var stubbedURL: URL?
    
    func encodeWikipediaURL(latitude: Double, longitude: Double) -> URL? {
        return stubbedURL
    }
}
