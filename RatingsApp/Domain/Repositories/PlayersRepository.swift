//
//  PlayersRepository.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

protocol PlayersRepositoryProtocol: Sendable {
    func getPlayers(offset: Int, limit: Int, query: String?) async throws -> [Player]
    func getPlayer(id: Int) async throws -> Player
}
