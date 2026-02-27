//
//  PlayersLocalDataSource.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation
import SwiftData

protocol PlayersLocalDataSourceProtocol: Sendable {
    func getPlayers(offset: Int, limit: Int, query: String?) async throws -> [Player]
    func getPlayer(id: Int) async throws -> Player
    func setPlayers(_ players: [Player]) async
}

actor PlayersLocalDataSource: PlayersLocalDataSourceProtocol {
    enum StorageError: Error {
        case dataNotFound
    }
    
    private let container: ModelContainer
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    private var context: ModelContext {
        ModelContext(container)
    }
        
    func clear() async {
        let ctx = context
        do {
            // SwiftData permite borrar todos los registros de un modelo de forma eficiente
            try ctx.delete(model: PlayerEntity.self)
            try ctx.save()
        } catch {
            // TODO: - Logger
        }
    }
    
    func setPlayers(_ players: [Player]) async {
        let ctx = context
        
        for player in players {
            let entity = PlayerEntity(from: player)
            ctx.insert(entity)
        }
        
        do {
            try ctx.save()
        } catch {
            // TODO: - Logger
        }
    }
    
    func getPlayer(id: Int) async throws -> Player {
        let ctx = context
        var descriptor = FetchDescriptor<PlayerEntity>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        
        guard let entity = try ctx.fetch(descriptor).first else {
            throw StorageError.dataNotFound
        }
        
        return entity.toDomain()
    }
    
    func getPlayers(offset: Int, limit: Int, query: String?) async throws -> [Player] {
        let ctx = context
        var descriptor = FetchDescriptor<PlayerEntity>()
        
        if let query = query, !query.isEmpty {
            descriptor.predicate = #Predicate<PlayerEntity> { entity in
                entity.firstName.localizedStandardContains(query) ||
                entity.lastName.localizedStandardContains(query)
            }
        }
        
        descriptor.sortBy = [SortDescriptor(\.overallRating, order: .reverse)]
        
        descriptor.fetchOffset = offset
        descriptor.fetchLimit = limit
        
        let entities = try ctx.fetch(descriptor)
        return entities.map { $0.toDomain() }
    }
}
