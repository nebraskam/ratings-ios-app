//
//  PlayersLocalDataSourceMock.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation

@testable import RatingsApp

actor PlayersLocalDataSourceMock: PlayersLocalDataSourceProtocol {
    private(set) var getPlayersMockResult: Result<[Player], Error> = .success([])
    private(set) var getPlayerMockResult: Result<Player, Error>?
    private(set) var getPlayersCalls: [(offset: Int, limit: Int, query: String?)] = []
    private(set) var getPlayerCalls: [Int] = []
    private(set) var setPlayersCalls: [[Player]] = []
    
    func getPlayers(offset: Int, limit: Int, query: String?) async throws -> [Player] {
        getPlayersCalls.append((offset: offset, limit: limit, query: query))
        return try getPlayersMockResult.get()
    }
    
    func setPlayers(_ players: [Player]) async {
        setPlayersCalls.append(players)
    }
    
    func getPlayer(id: Int) async throws -> Player {
        guard let result = getPlayerMockResult else {
            fatalError("getPlayerMockResult not set")
        }
        
        let player = try result.get()
        getPlayerCalls.append(id)
        return player
    }
    
    func setGetPlayersMockResult(_ result: Result<[Player], Error>) {
        self.getPlayersMockResult = result
    }
    
    func setGetPlayerMockResult(_ result: Result<Player, Error>?) {
        self.getPlayerMockResult = result
    }
}
