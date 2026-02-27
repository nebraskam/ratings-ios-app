//
//  PlayerEntity.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation
import SwiftData

@Model
final class PlayerEntity {
    @Attribute(.unique) var id: Int
    
    var rank: Int
    var firstName: String
    var lastName: String
    var commonName: String?
    var overallRating: Int
    var position: String
    var avatarUrl: String
    var shieldUrl: String?
    
    var pace: Int
    var shooting: Int
    var passing: Int
    var dribbling: Int
    var defending: Int
    var physical: Int
        
    init(from domain: Player) {
        self.id = domain.id
        self.rank = domain.rank
        self.firstName = domain.firstName
        self.lastName = domain.lastName
        self.commonName = domain.commonName
        self.overallRating = domain.overallRating
        self.position = domain.position
        self.avatarUrl = domain.avatarUrl
        self.shieldUrl = domain.shieldUrl
        self.pace = domain.pace
        self.shooting = domain.shooting
        self.passing = domain.passing
        self.dribbling = domain.dribbling
        self.defending = domain.defending
        self.physical = domain.physical
    }
    
    func toDomain() -> Player {
        return Player(
            id: self.id,
            rank: self.rank,
            firstName: self.firstName,
            lastName: self.lastName,
            commonName: self.commonName,
            overallRating: self.overallRating,
            position: self.position,
            avatarUrl: self.avatarUrl,
            shieldUrl: self.shieldUrl,
            pace: self.pace,
            shooting: self.shooting,
            passing: self.passing,
            dribbling: self.dribbling,
            defending: self.defending,
            physical: self.physical
        )
    }
}
