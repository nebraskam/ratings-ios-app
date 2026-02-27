//
//  PlayersRepositoryMock.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation

@testable import RatingsApp

actor PlayersRepositoryMock: PlayersRepositoryProtocol {
    private(set) var getPlayersResultMock: Result<[Player], Error> = .success([])
    private(set) var getPlayersCalls: [(offset: Int, limit: Int, query: String?)] = []
    
    private(set) var getPlayerResultMock: Result<Player, Error>?
    private(set) var getPlayerCalls: [Int] = []

    func getPlayers(offset: Int, limit: Int, query: String?) async throws -> [Player] {
        getPlayersCalls.append((offset: offset, limit: limit, query: query))
        return try getPlayersResultMock.get()
    }
    
    func getPlayer(id: Int) async throws -> Player {
        guard let result = getPlayerResultMock else {
            fatalError("getPlayerResultMock was not set")
        }
        
        getPlayerCalls.append(id)
        return try result.get()
    }
    
    func setGetPlayersResultMock(_ result: Result<[Player], Error>) {
        getPlayersResultMock = result
    }
    
    func setGetPlayerResultMock(_ result: Result<Player, Error>?) {
        getPlayerResultMock = result
    }
}
