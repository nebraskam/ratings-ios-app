//
//  PlayerUseCaseMock.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation

@testable import RatingsApp

@MainActor
final class PlayerUseCaseMock: GetPlayerUseCaseProtocol {
    var mockResult: Result<Player, Error>?
    private(set) var executeCalls: [Int] = []

    func execute(playerId: Int) async throws -> Player {
        guard let mockResult else {
            fatalError("missing mock result")
        }

        executeCalls.append(playerId)
        return try mockResult.get()
    }
}
