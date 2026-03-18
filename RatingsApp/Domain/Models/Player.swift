//
//  Player.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation
struct Player: Identifiable, Equatable {
    let id: Int
    let rank: Int
    let firstName: String
    let lastName: String
    let commonName: String?
    let overallRating: Int
    
    // Player's primary position (e.g., "ST", "CM", "GK")
    let position: String
    
    // Image URLs
    let avatarUrl: String
    let shieldUrl: String?
    
    // Extended attributes (Main game stats)
    let pace: Int
    let shooting: Int
    let passing: Int
    let dribbling: Int
    let defending: Int
    let physical: Int
    
    // MARK: - Domain Logic
    
    /// Calculates the name to be displayed in the UI.
    /// Business rule: If 'commonName' exists (e.g., "Vini Jr."), it is used.
    /// Otherwise, 'firstName' and 'lastName' are concatenated (e.g., "Mohamed Salah").
    var displayName: String {
        if let commonName = commonName, !commonName.isEmpty {
            return commonName
        }
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
