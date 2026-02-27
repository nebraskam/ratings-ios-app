//
//  GetPlayersUseCase.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

protocol GetPlayersUseCaseProtocol: Sendable {
    func execute(offset: Int, limit: Int, query: String?) async throws -> [Player]
}

actor GetPlayersUseCase: GetPlayersUseCaseProtocol {
    let repository: PlayersRepositoryProtocol
    
    init(repository: PlayersRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(offset: Int, limit: Int, query: String?) async throws -> [Player] {
        try await repository.getPlayers(offset: offset, limit: limit, query: query)
    }
}
