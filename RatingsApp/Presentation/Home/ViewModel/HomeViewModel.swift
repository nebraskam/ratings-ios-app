//
//  HomeViewModel.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var state: HomeViewState = .idle
    @Published private(set) var players: [PlayerRenderModel] = []
    @Published private(set) var isPaginating: Bool = false
    @Published var searchText: String = ""
    
    // MARK: - Dependencies
    private let getPlayersUseCase: GetPlayersUseCaseProtocol
    private let router: AppRouterProtocol

    // MARK: - Properties
    let localizedStrings = LocalizedStrings()
    private var cancellables = Set<AnyCancellable>()
    private var currentOffset: Int = .zero
    
    // MARK: - Init
    init(getPlayersUseCase: GetPlayersUseCaseProtocol, router: AppRouterProtocol) {
        self.getPlayersUseCase = getPlayersUseCase
        self.router = router
        setupSearchSubscription()
    }
    
    // MARK: - View Actions
    func loadInitialData() async {
        guard state == .idle else {
            return
        }
        
        await getData()
    }
    
    func rowDidTapped(player: PlayerRenderModel) {
        router.navigate(to: .detail(playerId: player.id))
    }
    
    func refresh() async {
        await getData()
    }
    
    func loadNextPage(currentPlayerId: Int) async {
        guard !isPaginating, searchText.isEmpty else { return }
        
        if players.last?.id == currentPlayerId {
            isPaginating = true
            
            do {
                currentOffset += Constants.pageSize
                let response = try await getPlayersUseCase.execute(offset: currentOffset, limit: Constants.pageSize, query: nil)
                players.append(contentsOf: response.map(PlayerRenderModel.init))
            } catch {
                // TODO: - Logger error pagination
            }
            
            isPaginating = false
        }
    }
}

// MARK: - Get Data
private extension HomeViewModel {
    func getData() async {
        state = .loading
         do {
             currentOffset = .zero
             let response = try await getPlayersUseCase.execute(offset: .zero, limit: Constants.pageSize, query: nil)
             players = response.map(PlayerRenderModel.init)
             state = players.isEmpty ? .empty : .success
         } catch {
             state = .error(localizedStrings.error.searchError)
         }
    }
}

// MARK: - Support Search
private extension HomeViewModel {
    func setupSearchSubscription() {
        $searchText
            .dropFirst()
            .debounce(for: .milliseconds(Constants.searchDebounce), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.searchPlayers(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    func searchPlayers(query: String) async {
        do {
            let response = try await getPlayersUseCase.execute(offset: .zero, limit: Constants.pageSize, query: query)
            players = response.map(PlayerRenderModel.init)
            state = players.isEmpty ? .empty : .success
        } catch {
            state = .error(localizedStrings.error.searchError)
        }
    }
}

// MARK: - Constants
private extension HomeViewModel {
    enum Constants {
        static let pageSize = 20
        static let searchDebounce = 500
    }
}

// MARK: - Static text
extension HomeViewModel {
    struct LocalizedStrings {
        struct Header {
            let title = "FC26"
            let prompt = "Search for a player by name."
        }
        
        struct Loader {
            let loadingPlayers = "Loading players..."
        }
        
        struct Empty {
            let title = "No players found."
            let description = "Try searching for a player by name."
        }
        
        struct Error {
            let title = "Oops something went wrong. Please try again later."
            let retryButton = "Try again"
            let searchError = "An error occurred while searching players."
        }
        
        let header = Header()
        let loader = Loader()
        let empty = Empty()
        let error = Error()
    }
}
