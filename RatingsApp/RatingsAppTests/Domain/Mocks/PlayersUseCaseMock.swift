//
//  PlayersUseCaseMock.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation

@testable import RatingsApp

@MainActor
final class PlayersUseCaseMock: GetPlayersUseCaseProtocol {
    var mockResult: Result<[Player], Error> = .success([])
    private(set) var executeCalls: [(offset: Int, limit: Int, query: String?)] = []

    func execute(offset: Int, limit: Int, query: String?) async throws -> [Player] {
        executeCalls.append((offset: offset, limit: limit, query: query))
        return try mockResult.get()
    }
}
