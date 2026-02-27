//
//  PlayerAvatarCard.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import SwiftUI

struct PlayerAvatarCard: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Image(systemName: "person.fill")
                .font(.system(size: 30))
                .foregroundColor(.gray.opacity(0.4))
        }
        .frame(width: 70, height: 70)
        .background(
            LinearGradient(
                colors: [Color(.secondarySystemBackground), Color(.systemBackground)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
