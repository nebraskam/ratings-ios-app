//
//  PlayerRemoteDataSourceMock.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation

@testable import RatingsApp

actor PlayersRemoteDataSourceMock: PlayersRemoteDataSourceProtocol {
    private(set) var mockResult: Result<[Player], Error> = .success([])
    private(set) var getPlayersCalls: [(offset: Int, limit: Int)] = []
    
    func getPlayers(offset: Int, limit: Int) async throws -> [Player] {
        getPlayersCalls.append((offset: offset, limit: limit))
        return try mockResult.get()
    }
    
    func setMockResult(_ result: Result<[Player], Error>) {
        self.mockResult = result
    }
}
