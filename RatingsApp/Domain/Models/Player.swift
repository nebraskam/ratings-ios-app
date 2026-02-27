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
    
    // Posición principal del jugador (ej. "DC", "MC", "POR")
    let position: String
    
    // URLs para las imágenes
    let avatarUrl: String
    let shieldUrl: String?
    
    // Atributos extendidos (Stats principales del juego)
    let pace: Int
    let shooting: Int
    let passing: Int
    let dribbling: Int
    let defending: Int
    let physical: Int
    
    // MARK: - Lógica de Dominio
    
    /// Calcula el nombre que se debe mostrar en la UI.
    /// Regla de negocio: Si tiene 'commonName' (ej. "Vini Jr."), se usa ese.
    /// Si no, se concatena el 'firstName' y 'lastName' (ej. "Mohamed Salah").
    var displayName: String {
        if let commonName = commonName, !commonName.isEmpty {
            return commonName
        }
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
