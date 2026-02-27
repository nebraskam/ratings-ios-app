//
//  PlayerRowView.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import SwiftUI

struct PlayerRowView: View {
    let player: PlayerRenderModel
    
    var body: some View {
        HStack(spacing: 16) {
            PlayerAvatarCard(url: player.avatarUrl)
            playerInfoSection
            Spacer()
            chevronIcon
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground).opacity(0.5))
        .cornerRadius(12)
        .padding(.horizontal, 4)
    }
}

// MARK: - Subviews
private extension PlayerRowView {
    var playerInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(player.displayName)
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                Label(player.position, systemImage: "figure.soccer")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.accentColor.opacity(0.1))
                    .clipShape(Capsule())
                
                Text("OVR \(player.overallRating)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.caption2.bold())
            .foregroundColor(.secondary.opacity(0.5))
    }
}
