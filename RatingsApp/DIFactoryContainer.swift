//
//  DIContainer.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class DIFactoryContainer {
    // MARK: - SwiftData Container init
    static private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PlayerEntity.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("SwiftData of ModelContainer could not be loaded: \(error)")
        }
    }()
    
    static var Router = AppRouter()

    // MARK: - Data
    static func getPlayersRemoteDataSource() -> PlayersRemoteDataSourceProtocol {
        PlayersRemoteDataSource()
    }
    
    static func getPlayersLocalDataSource() -> PlayersLocalDataSourceProtocol {
        PlayersLocalDataSource(container: sharedModelContainer)
    }

    static func getPlayersRepository() -> PlayersRepositoryProtocol {
        PlayersRepository(
            remoteDataSource: getPlayersRemoteDataSource(),
            localDataSource: getPlayersLocalDataSource()
        )
    }
    
    // MARK: - Domain
    static func getPlayerUseCase() -> GetPlayersUseCaseProtocol {
        GetPlayersUseCase(repository: getPlayersRepository())
    }
    
    static func getPlayerUseCase() -> GetPlayerUseCaseProtocol {
        GetPlayerUseCase(repository: getPlayersRepository())
    }
    
    // MARK: - Presentation
    static func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(getPlayersUseCase: getPlayerUseCase(), router: Router)
    }
    
    static func makeHomeScreen() -> some View {
        HomeScreen(viewModel: makeHomeViewModel())
    }
    
    static func makeDetailViewModel(playerId: Int) -> DetailViewModel {
        DetailViewModel(playerId: playerId, useCase: getPlayerUseCase())
    }
    
    static func makeDetailScreen(playerId: Int) -> some View {
        DetailScreen(viewModel: makeDetailViewModel(playerId: playerId))
    }
}
