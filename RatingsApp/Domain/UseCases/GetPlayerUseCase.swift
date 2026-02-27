//
//  GetPlayerUseCase.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

protocol GetPlayerUseCaseProtocol: Sendable {
    func execute(playerId: Int) async throws -> Player
}

actor GetPlayerUseCase: GetPlayerUseCaseProtocol {
    let repository: PlayersRepositoryProtocol
    
    init(repository: PlayersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(playerId: Int) async throws -> Player {
        try await repository.getPlayer(id: playerId)
    }
}
