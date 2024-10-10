//
//  HTTPClient.swift
//  Places
//
//  Created by Omar Bassyouni on 10/10/2024.
//

import Foundation

public protocol HTTPClient {
    func get(url: URL) async throws -> Data
}
