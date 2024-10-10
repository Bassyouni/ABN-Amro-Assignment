//
//  RemotePlacesLoaderTests.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import XCTest
import Places

final class RemotePlacesLoaderTests: XCTestCase {
    private let env = Environment()
    
    func test_init_doesNothing() {
        _ = makeSUT()
        
        XCTAssertEqual(env.client.requestedURLs, [])
    }
}

extension RemotePlacesLoaderTests {
    private struct Environment {
        let client = HTTPClientSpy()
    }
    
    func makeSUT(url: URL = URL(string: "www.a-url.com")!, file: StaticString = #file, line: UInt = #line) -> RemotePlacesLoader {
        let sut = RemotePlacesLoader(url: url, httpClient: env.client)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

private final class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    var stubbedGetResult: Result<Data, Error> = .failure(NSError())
    
    func get(url: URL) async throws -> Data {
        requestedURLs.append(url)
        return try stubbedGetResult.get()
    }
}
