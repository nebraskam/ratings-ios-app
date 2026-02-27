//
//  DetailViewModelTests.swift
//  RatingsAppTests
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Testing
import Foundation
import Combine
@testable import RatingsApp

@Suite("HomeViewModel Tests")
@MainActor
struct HomeViewModelTests {
    private var sut: HomeViewModel
    private var mockUseCase: PlayersUseCaseMock
    private var mockRouter: AppRouterMock
    
    init() {
        mockUseCase = PlayersUseCaseMock()
        mockRouter = AppRouterMock()
        sut = HomeViewModel(getPlayersUseCase: mockUseCase, router: mockRouter)
    }
    
    // MARK: - Initial State
    @Test
    func testInitialState() {
        #expect(sut.state == .idle)
        #expect(sut.players.isEmpty)
        #expect(sut.isPaginating == false)
    }
    
    // MARK: - Load Initial Data
    @Test
    func testLoadInitialDataSuccess() async throws {
        // Given
        let players = [Player.mock(id: 1), Player.mock(id: 2)]
        mockUseCase.mockResult = .success(players)
        
        // When
        await sut.loadInitialData()
        
        // Then
        #expect(sut.state == .success)
        #expect(sut.players.count == 2)
        #expect(mockUseCase.executeCalls.last?.offset == 0)
    }
    
    @Test
    func testLoadInitialDataEmpty() async {
        // Given
        mockUseCase.mockResult = .success([])
        
        // When
        await sut.loadInitialData()
        
        // Then
        #expect(sut.state == .empty)
        #expect(sut.players.isEmpty)
    }
    
    @Test
    func testLoadInitialDataError() async {
        // Given
        struct DummyError: Error {}
        mockUseCase.mockResult = .failure(DummyError())
        
        // When
        await sut.loadInitialData()
        
        // Then
        #expect(sut.state == .error(sut.localizedStrings.error.searchError))
    }
    
    // MARK: - Navigation
    @Test
    func testRowDidTapped() {
        // Given
        let player = PlayerRenderModel(player: Player.mock(id: 99))
        
        // When
        sut.rowDidTapped(player: player)
        
        // Then
        if case .detail(let id) = mockRouter.navigatedDestination {
            #expect(id == 99)
        } else {
            Issue.record("incorrect path")
        }
    }
    
    // MARK: - Pagination
    @Test
    func testLoadNextPageSuccess() async throws {
        // Given
        let firstPage = (1...20).map { Player.mock(id: $0) }
        mockUseCase.mockResult = .success(firstPage)
        await sut.loadInitialData()
        
        // When
        let secondPage = (21...40).map { Player.mock(id: $0) }
        mockUseCase.mockResult = .success(secondPage)
        await sut.loadNextPage(currentPlayerId: 20)
        
        // Then
        #expect(sut.players.count == 40)
        #expect(mockUseCase.executeCalls.last?.offset == 20)
        #expect(mockUseCase.executeCalls.count == 2)
    }
    
    @Test
    func testLoadNextPageIgnoredIfNotLast() async {
        // Given
        mockUseCase.mockResult = .success([Player.mock(id: 1), Player.mock(id: 2)])
        await sut.loadInitialData()
        
        // When
        await sut.loadNextPage(currentPlayerId: 1)
        
        // Then
        #expect(mockUseCase.executeCalls.count == 1)
    }
    
    // MARK: - Search
    @Test
    func testSearchDebounce() async throws {
        // Given
        mockUseCase.mockResult = .success([Player.mock(id: 10)])
        
        // When
        sut.searchText = "Messi"
        try await Task.sleep(nanoseconds: 600_000_000)
        
        // Then
        #expect(mockUseCase.executeCalls.last?.query == "Messi")
        #expect(sut.state == .success)
        #expect(sut.players.count == 1)
    }
    
    // MARK: - Refresh
    @Test
    func testRefresh() async throws {
        // Given
        let players = [Player.mock(id: 1), Player.mock(id: 2)]
        mockUseCase.mockResult = .success(players)
        
        // When
        await sut.refresh()
        
        // Then
        #expect(sut.state == .success)
        #expect(sut.players.count == 2)
        #expect(mockUseCase.executeCalls.last?.offset == 0)
    }
    
}
