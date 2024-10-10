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
    
    func test_loadPlaces_requestsDataFromURL() async {
        let url = URL(string: "www.a-url.com")
        let sut = makeSUT(url: url!)
        
        _ = try? await sut.loadPlaces()
        
        XCTAssertEqual(env.client.requestedURLs, [url])
    }
    
    func test_loadPlacesTwice_requestsDataFromURLTwice() async {
        let url = URL(string: "www.a-url.com")
        let sut = makeSUT(url: url!)
        
        _ = try? await sut.loadPlaces()
        _ = try? await sut.loadPlaces()
        
        XCTAssertEqual(env.client.requestedURLs, [url, url])
    }
    
    func test_loadPlaces_deliversErrorOnError() async {
        let sut = makeSUT()
        env.client.stubbedGetResult = .failure(NSError(domain: "test", code: 0))
        
        do  {
            _ = try await sut.loadPlaces()
            XCTFail("Expected load places to throw on error")
        } catch {
            XCTAssertEqual(error as? RemotePlacesLoader.Error, RemotePlacesLoader.Error.networkError)
        }
    }
    
    func test_loadPlaces_deliversErrorOnResponseWithInvalidJson() async {
        let sut = makeSUT()
        env.client.stubbedGetResult = .success(Data("".utf8))
        
        do  {
            _ = try await sut.loadPlaces()
            XCTFail("Expected load places to throw on error")
        } catch {
            XCTAssertEqual(error as? RemotePlacesLoader.Error, RemotePlacesLoader.Error.invalidData)
        }
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
