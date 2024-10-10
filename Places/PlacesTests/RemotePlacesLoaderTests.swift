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
    
    func test_loadPlaces_requestsDataFromURL() async throws {
        let url = URL(string: "www.a-url.com")
        let sut = makeSUT(url: url!)
        
        _ = try await sut.loadPlaces()
        
        XCTAssertEqual(env.client.requestedURLs, [url])
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
    var stubbedGetResult: Result<Data, Error> = .success(Data())
    
    func get(url: URL) async throws -> Data {
        requestedURLs.append(url)
        return try stubbedGetResult.get()
    }
}
