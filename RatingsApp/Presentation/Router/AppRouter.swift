//
//  AppRouter.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import SwiftUI
import Combine

protocol AppRouterProtocol {
    func navigate(to destination: AppRoute)
    func getScreenFrom(destination: AppRoute) -> any View
}

@MainActor
final class AppRouter: ObservableObject, AppRouterProtocol {
    @Published var path = NavigationPath()
    
    func navigate(to destination: AppRoute) {
        path.append(destination)
    }
    
    func getScreenFrom(destination: AppRoute) -> any View {
        switch destination {
        case .home:
            DIFactoryContainer.makeHomeScreen()
        case .detail(playerId: let id):
            DIFactoryContainer.makeDetailScreen(playerId: id)
        }
    }
}
