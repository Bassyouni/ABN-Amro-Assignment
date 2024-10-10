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
     
    func test_loadPlaces_deliversColorsOnHttpResponseWithValidJsonObject() async throws {
        let sut = makeSUT()
        
        let place1 = makePlace(latitude: 1, longitude: 2.3)
        let place2 = makePlace(name: "London", latitude: 51.507351, longitude: -0.127758)
        let jsonData = makeJson([place1.json, place2.json])
        env.client.stubbedGetResult = .success(jsonData)
        
        let receivedPlaces = try await sut.loadPlaces()
        
        XCTAssertEqual(receivedPlaces.count, 2)
        XCTAssertEqual(receivedPlaces.first?.name, place1.model.name)
        XCTAssertEqual(receivedPlaces.first?.latitude, place1.model.latitude)
        XCTAssertEqual(receivedPlaces.first?.longitude, place1.model.longitude)
        XCTAssertEqual(receivedPlaces.last?.name, place2.model.name)
        XCTAssertEqual(receivedPlaces.last?.latitude, place2.model.latitude)
        XCTAssertEqual(receivedPlaces.last?.longitude, place2.model.longitude)
    }
}

extension RemotePlacesLoaderTests {
    private struct Environment {
        let client = HTTPClientSpy()
    }
    
    private func makeSUT(url: URL = URL(string: "www.a-url.com")!, file: StaticString = #file, line: UInt = #line) -> RemotePlacesLoader {
        let sut = RemotePlacesLoader(url: url, httpClient: env.client)
        checkForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makePlace(
        name: String? = nil,
        latitude: Double,
        longitude: Double
    ) -> (model: Place, json: [String: Any]) {
        let model = Place(name: name, latitude: latitude, longitude: longitude)
        
        let json: [String: Any] = [
            "name": model.name as Any?,
            "lat": model.latitude,
            "long": model.longitude
        ].reduce(into: [String: Any]()) { (acc, e) in
            if let value = e.value {
                acc[e.key] = value
            }
        }
        
        return (model, json)
    }
    
    private func makeJson(_ places: [[String: Any]]) -> Data {
        let json = ["locations": places]
        return try! JSONSerialization.data(withJSONObject: json)
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
