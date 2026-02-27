//
//  GetPlayersUseCaseTests.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Testing
import Foundation
@testable import RatingsApp

@Suite("GetPlayersUseCase Tests")
struct GetPlayersUseCaseTests {
    private var sut: GetPlayersUseCase
    private var repositoryMock: PlayersRepositoryMock
    
    init() {
        repositoryMock = PlayersRepositoryMock()
        sut = GetPlayersUseCase(repository: repositoryMock)
    }
    
    @Test
    func executePassesCorrectParameters() async throws {
        // Given
        let expectedOffset = 10
        let expectedLimit = 20
        let expectedQuery = "Vinícius"
        
        // When
        _ = try? await sut.execute(offset: expectedOffset, limit: expectedLimit, query: expectedQuery)
        
        // Then
        let capturedOffset = await repositoryMock.getPlayersCalls.last?.offset
        let capturedLimit = await repositoryMock.getPlayersCalls.last?.limit
        let capturedQuery = await repositoryMock.getPlayersCalls.last?.query
        
        #expect(capturedOffset == expectedOffset)
        #expect(capturedLimit == expectedLimit)
        #expect(capturedQuery == expectedQuery)
    }
    
    @Test
    func executeReturnsPlayersOnSuccess() async throws {
        // Given
        let expectedPlayers = [Player.mock(id: 1), Player.mock(id: 2)]
        await repositoryMock.setGetPlayersResultMock(.success(expectedPlayers))
        
        // When
        let result = try await sut.execute(offset: 0, limit: 20, query: nil)
        
        // Then
        #expect(result == expectedPlayers)
    }
    
    @Test
    func executePropagatesErrorOnFailure() async throws {
        // Given
        struct MockError: Error {}
        await repositoryMock.setGetPlayersResultMock(.failure(MockError()))
        
        // When - Then
        await #expect(throws: MockError.self) {
            try await sut.execute(offset: 0, limit: 20, query: nil)
        }
    }
}
