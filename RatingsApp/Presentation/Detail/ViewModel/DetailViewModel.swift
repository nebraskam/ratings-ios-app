//
//  DetailViewModel.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation
import Combine

@MainActor
final class DetailViewModel: ObservableObject {
    // MARK: - Dependencies
    private let playerId: Int
    private let useCase: GetPlayerUseCaseProtocol

    // MARK: - Publishers
    @Published private(set) var state: DetailViewState = .loading
    
    let localizedStrings = LocalizedStrings()
    
    // MARK: - Init
    init(playerId: Int, useCase: GetPlayerUseCaseProtocol) {
        self.playerId = playerId
        self.useCase = useCase
    }
    
    // MARK: - View Actions
    func loadPlayerDetail() async {
        state = .loading
        do {
            let player = try await useCase.execute(playerId: playerId)
            state = .success(PlayerRenderModel(player: player))
        } catch {
            state = .error(localizedStrings.error.title)
        }
    }
}

// MARK: - Static text
extension DetailViewModel {
    struct LocalizedStrings {
        struct Loader {
            let loadingProfile = "Loading profile..."
        }
        
        struct Content {
            let pace = "RIT"
            let shooting = "TIRO"
            let passing = "PASE"
            let dribbling = "REG"
            let defending = "DEF"
            let physical = "FÍS"
            let ovr = "OVR"
            let attributes = "Atributtes"
        }
        
        struct Error {
            let title = "Oops something went wrong. Please try again later."
            let retryButton = "Try again"
        }
        
        let loader = Loader()
        let content = Content()
        let error = Error()
    }
}
