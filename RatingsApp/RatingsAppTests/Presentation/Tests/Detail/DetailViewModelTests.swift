//
//  DetailViewModelTests.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Testing
import Foundation
@testable import RatingsApp

@Suite("DetailViewModel Tests")
@MainActor
struct DetailViewModelTests {
    private var sut: DetailViewModel
    private var mockUseCase: PlayerUseCaseMock
    private let testPlayerId = 209331
    
    init() {
        mockUseCase = PlayerUseCaseMock()
        sut = DetailViewModel(playerId: testPlayerId, useCase: mockUseCase)
    }
    
    @Test
    func testInitialState() {
        #expect(sut.state == .loading)
    }
    
    @Test
    func testLoadPlayerDetailSuccess() async throws {
        // Given
        let mockPlayer = Player.mock(id: testPlayerId)
        mockUseCase.mockResult = .success(mockPlayer)
        
        // When
        await sut.loadPlayerDetail()
        
        // Then
        if case .success(let renderModel) = sut.state {
            #expect(renderModel.id == testPlayerId)
            #expect(renderModel.displayName == mockPlayer.displayName)
        } else {
            Issue.record("invalid state")
        }
    }
    
    @Test
    func testLoadPlayerDetailFailure() async {
        // Given
        struct DummyError: Error {}
        mockUseCase.mockResult = .failure(DummyError())
        
        // When
        await sut.loadPlayerDetail()
        
        // Then
        if case .error(let message) = sut.state {
            #expect(message == sut.localizedStrings.error.title)
        } else {
            Issue.record("Invalid state")
        }
    }
    
    @Test
    func testLoadingStateDuringExecution() async {
        // Given
        mockUseCase.mockResult = .success(Player.mock(id: testPlayerId))
        
        // When
        await sut.loadPlayerDetail()
        
        // Then
        #expect(sut.state != .loading)
    }
}
