//
//  RatingsAppApp.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import SwiftUI

@main
struct RatingsAppApp: App {
    @StateObject private var router = DIContainer.Router
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                DIContainer.makeHomeScreen()
                    .navigationDestination(for: AppRoute.self) { destination in
                        AnyView(router.getScreenFrom(destination: destination))
                    }
            }
        }
    }
}
