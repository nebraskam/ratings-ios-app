//
//  AppRouterMock.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation
import SwiftUI

@testable import RatingsApp

final class AppRouterMock: AppRouterProtocol {
    private(set) var navigatedDestination: AppRoute?
    
    func getScreenFrom(destination: RatingsApp.AppRoute) -> any View {
        EmptyView()
    }

    func navigate(to destination: AppRoute) {
        navigatedDestination = destination
    }
}
