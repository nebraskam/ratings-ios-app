//
//  PlayerRenderModel.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

struct PlayerRenderModel: Identifiable, Equatable {
    let id: Int
    let displayName: String
    let overallRating: Int
    let position: String
    let avatarUrl: URL?
    let shieldUrl: URL?
    
    let pace: Int
    let shooting: Int
    let passing: Int
    let dribbling: Int
    let defending: Int
    let physical: Int
    
    init(player: Player) {
        self.id = player.id
        self.displayName = player.displayName
        self.overallRating = player.overallRating
        self.position = player.position
        self.avatarUrl = URL(string: player.avatarUrl)
        self.pace = player.pace
        self.shooting = player.shooting
        self.dribbling = player.dribbling
        self.defending = player.defending
        self.physical = player.physical
        self.passing = player.passing
        self.shieldUrl = player.shieldUrl.flatMap { URL(string: $0) }
    }
}
