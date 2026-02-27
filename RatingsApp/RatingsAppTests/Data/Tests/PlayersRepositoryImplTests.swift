//
//  PlayersRepositoryImplTests.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Testing
import Foundation
@testable import RatingsApp

@Suite
struct PlayersRepositoryTests {
    private var sut: PlayersRepository
    private var remoteDataSourceMock: PlayersRemoteDataSourceMock
    private var localDataSourceMock: PlayersLocalDataSourceMock
    
    init() {
        remoteDataSourceMock = PlayersRemoteDataSourceMock()
        localDataSourceMock = PlayersLocalDataSourceMock()
        sut = PlayersRepository(remoteDataSource: remoteDataSourceMock, localDataSource: localDataSourceMock)
    }
    
    @Test
    func getPlayersWithQuery() async throws {
        // Given
        let expectedPlayers = [Player.mock(id: 1, name: "Messi")]
        await localDataSourceMock.setGetPlayersMockResult(.success(expectedPlayers))
        
        // When
        let result = try await sut.getPlayers(offset: 0, limit: 10, query: "Messi")
        
        // Then
        let remoteCalled = await !remoteDataSourceMock.getPlayersCalls.isEmpty
        #expect(result == expectedPlayers)
        #expect(remoteCalled == false)
    }
    
    @Test func getPlayersRemoteSync() async throws {
        // Given
        let remotePlayers = [Player.mock(id: 1), Player.mock(id: 2)]
        await remoteDataSourceMock.setMockResult(.success(remotePlayers))
        await localDataSourceMock.setGetPlayersMockResult(.success(remotePlayers))
                
        // When
        let result = try await sut.getPlayers(offset: 0, limit: 10, query: nil)
        
        // Then
        let playersSaved = await localDataSourceMock.setPlayersCalls.last
        let remoteCalled = await !remoteDataSourceMock.getPlayersCalls.isEmpty
        
        #expect(remoteCalled == true)
        #expect(playersSaved?.count == 2)
        #expect(result.count == 2)
    }
    
    @Test
    func getPlayersRemoteFailureFallback() async throws {
        // Given
        let cachedPlayers = [Player.mock(id: 5)]
        await remoteDataSourceMock.setMockResult(.failure(NSError(domain: "Network", code: -1)))
        await localDataSourceMock.setGetPlayersMockResult(.success(cachedPlayers))
                
        // When
        let result = try await sut.getPlayers(offset: 0, limit: 10, query: nil)
        
        // Then
        #expect(result == cachedPlayers)
    }
    
    @Test
    func getSinglePlayer() async throws {
        // Given
        let expectedPlayer = Player.mock(id: 10)
        await localDataSourceMock.setGetPlayerMockResult(.success(expectedPlayer))
                
        // When
        let result = try await sut.getPlayer(id: 10)
        
        // Then
        #expect(result.id == 10)
    }
}
