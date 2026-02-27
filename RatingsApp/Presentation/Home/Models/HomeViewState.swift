//
//  HomeViewState.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

enum HomeViewState: Equatable {
    case idle
    case loading
    case success
    case empty
    case error(String)
}
