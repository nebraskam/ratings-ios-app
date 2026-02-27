//
//  GetPlayerUseCaseTests.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Testing
import Foundation
@testable import RatingsApp

@Suite("GetPlayersUseCase Tests")
struct GetPlayerUseCaseTests {
    private var sut: GetPlayerUseCase
    private var repositoryMock: PlayersRepositoryMock
    
    init() {
        repositoryMock = PlayersRepositoryMock()
        sut = GetPlayerUseCase(repository: repositoryMock)
    }
    
    @Test
    func executePassesCorrectParameters() async throws {
        // Given
        let playerId = 10
        await repositoryMock.setGetPlayerResultMock(.success(Player.mock(id: 10)))
        
        // When
        _ = try? await sut.execute(playerId: playerId)
        
        // Then
        let capturedPlayerId = await repositoryMock.getPlayerCalls.last
        #expect(capturedPlayerId == playerId)

    }
    
    @Test
    func executeReturnsPlayerOnSuccess() async throws {
        // Given
        let expectedPlayer = Player.mock(id: 1)
        await repositoryMock.setGetPlayerResultMock(.success(expectedPlayer))
        
        // When
        let result = try await sut.execute(playerId: 1)
        
        // Then
        #expect(result == expectedPlayer)
    }
    
    @Test
    func executePropagatesErrorOnFailure() async throws {
        // Given
        struct MockError: Error {}
        await repositoryMock.setGetPlayerResultMock(.failure(MockError()))
        
        // When - Then
        await #expect(throws: MockError.self) {
            try await sut.execute(playerId: 1)
        }
    }
}
