//
//  PlayerResponseDTO.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

nonisolated struct PlayerResponseDTO: Decodable {
    let items: [PlayerDTO]
    let totalItems: Int?
}

struct PlayerDTO: Decodable {
    let id: Int
    let rank: Int?
    let firstName: String
    let lastName: String
    let commonName: String?
    let overallRating: Int
    let avatarUrl: String
    let shieldUrl: String?
    
    // Objetos anidados
    let position: PositionDTO
    let stats: StatsDTO
}

struct PositionDTO: Decodable {
    let shortLabel: String
}

struct StatsDTO: Decodable {
    let pac: StatValueDTO
    let sho: StatValueDTO
    let pas: StatValueDTO
    let dri: StatValueDTO
    let def: StatValueDTO
    let phy: StatValueDTO
}

struct StatValueDTO: Decodable {
    let value: Int
}

extension PlayerDTO {
    nonisolated func toDomain() -> Player {
        return Player(
            id: self.id,
            rank: self.rank ?? 0,
            firstName: self.firstName,
            lastName: self.lastName,
            commonName: self.commonName,
            overallRating: self.overallRating,
            position: self.position.shortLabel,
            avatarUrl: self.avatarUrl,
            shieldUrl: self.shieldUrl,
            pace: self.stats.pac.value,
            shooting: self.stats.sho.value,
            passing: self.stats.pas.value,
            dribbling: self.stats.dri.value,
            defending: self.stats.def.value,
            physical: self.stats.phy.value
        )
    }
}
