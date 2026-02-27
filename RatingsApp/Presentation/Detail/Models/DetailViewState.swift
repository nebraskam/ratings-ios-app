//
//  DetailViewState.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

enum DetailViewState: Equatable {
    case loading
    case success(PlayerRenderModel)
    case error(String)
}
