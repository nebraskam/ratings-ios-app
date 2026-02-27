//
//  PlayersRepositories.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

actor PlayersRepository: PlayersRepositoryProtocol {
    private let remoteDataSource: PlayersRemoteDataSourceProtocol
    private let localDataSource: PlayersLocalDataSourceProtocol
    
    init(remoteDataSource: PlayersRemoteDataSourceProtocol, localDataSource: PlayersLocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getPlayers(offset: Int, limit: Int, query: String?) async throws -> [Player] {
        if let query {
            return try await localDataSource.getPlayers(offset: offset, limit: limit, query: query)
        }
        
        do {
            let remotePlayers = try await remoteDataSource.getPlayers(offset: offset, limit: limit)
            if !remotePlayers.isEmpty {
                await localDataSource.setPlayers(remotePlayers)
            }
        } catch {
            // MARK: - TODO Logger failed remote players
        }
        
        return try await localDataSource.getPlayers(offset: offset, limit: limit, query: query)
    }
    
    func getPlayer(id: Int) async throws -> Player {
        try await localDataSource.getPlayer(id: id)
    }
}
