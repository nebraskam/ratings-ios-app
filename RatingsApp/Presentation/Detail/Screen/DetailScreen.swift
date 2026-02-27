//
//  DetailScreen.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import SwiftUI

struct DetailScreen: View {
    @StateObject var viewModel: DetailViewModel
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()
            content
        }
        .onAppear {
            Task {
                await viewModel.loadPlayerDetail()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - State
private extension DetailScreen {
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loaderView
        case .error(let message):
           errorView(message: message)
        case .success(let player):
            detailContent(player: player)
        }
    }
}

// MARK: - Define UI
private extension DetailScreen {
    var loaderView: some View {
        ProgressView(viewModel.localizedStrings.loader.loadingProfile)
    }
    
    func errorView(message: String) -> some View {
        ContentUnavailableView(viewModel.localizedStrings.error.title, systemImage: "person.fill.xmark", description: Text(message))
    }

    func detailContent(player: PlayerRenderModel) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                heroSection(player: player)
                statsGrid(player: player)
                Spacer()
            }
            .padding()
        }
    }
    
    func heroSection(player: PlayerRenderModel) -> some View {
        VStack(spacing: 16) {
            AsyncImage(url: player.shieldUrl ?? player.avatarUrl) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.gray.opacity(0.4))
            }
            .frame(width: 300, height: 200)
            
            VStack(spacing: 4) {
                Text(player.displayName)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                
                HStack {
                    Text(player.position)
                        .font(.headline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    
                    Text("\(viewModel.localizedStrings.content.ovr) \(player.overallRating)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    func statsGrid(player: PlayerRenderModel) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(viewModel.localizedStrings.content.attributes)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                StatCard(label: viewModel.localizedStrings.content.pace, value: player.pace)
                StatCard(label: viewModel.localizedStrings.content.shooting, value: player.shooting)
                StatCard(label: viewModel.localizedStrings.content.passing, value: player.passing)
                StatCard(label: viewModel.localizedStrings.content.dribbling, value: player.dribbling)
                StatCard(label: viewModel.localizedStrings.content.defending, value: player.defending)
                StatCard(label: viewModel.localizedStrings.content.physical, value: player.physical)
            }
        }
    }
}
