//
//  URLSessionHTTPClient.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func get(url: URL) async throws -> Data {
        let (data, _) = try await session.data(from: url)
        return data
    }
}
