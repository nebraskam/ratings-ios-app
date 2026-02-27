//
//  HomeScreen.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        content
            .onAppear {
                Task {
                    await viewModel.loadInitialData()
                }
            }
            .navigationTitle(viewModel.localizedStrings.header.title)
            .searchable(text: $viewModel.searchText, prompt: viewModel.localizedStrings.header.prompt)
            .refreshable {
                await viewModel.refresh()
            }
    }
}

// MARK: - State
private extension HomeScreen {
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading, .idle:
            loadingView
        case .empty:
            emptyView
        case .error(let message):
            errorView(message: message)
        case .success:
            playersListView
        }
    }
}

// MARK: - Components
private extension HomeScreen {
    var loadingView: some View {
        ProgressView(viewModel.localizedStrings.loader.loadingPlayers)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var emptyView: some View {
        ContentUnavailableView(
            viewModel.localizedStrings.empty.title,
            systemImage: "magnifyingglass",
            description: Text(viewModel.localizedStrings.empty.description)
        )
    }
    
    func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.red)
            Text(viewModel.localizedStrings.error.title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(viewModel.localizedStrings.error.retryButton) {
                Task { await viewModel.loadInitialData() }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var playersListView: some View {
        List {
            ForEach(viewModel.players) { player in
                PlayerRowView(player: player)
                    .onAppear {
                        Task {
                            await viewModel.loadNextPage(currentPlayerId: player.id)
                        }
                    }
                    .onTapGesture {
                        viewModel.rowDidTapped(player: player)
                    }
            }
            
            paginationIndicator
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    var paginationIndicator: some View {
        if viewModel.isPaginating {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .listRowSeparator(.hidden)
            .padding(.vertical, 8)
        }
    }
}
