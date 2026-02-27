//
//  NetworkError.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
}
