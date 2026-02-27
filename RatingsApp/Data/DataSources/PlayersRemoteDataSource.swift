//
//  PlayersRemoteDataSource.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 26/2/26.
//

import Foundation

protocol PlayersRemoteDataSourceProtocol: Sendable {
    func getPlayers(offset: Int, limit: Int) async throws -> [Player]
}

actor PlayersRemoteDataSource: PlayersRemoteDataSourceProtocol {
    private let session: URLSession
    private let baseURL = "https://drop-api.ea.com/rating/ea-sports-fc"
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func getPlayers(offset: Int, limit: Int) async throws -> [Player] {
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkError.invalidURL
        }
                
        let queryItems = [
            URLQueryItem(name: "locale", value: "es"),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await session.data(from: url)
        
        do {
            let decoder = JSONDecoder()
            let responseDTO = try decoder.decode(PlayerResponseDTO.self, from: data)
            return responseDTO.items.map { $0.toDomain() }
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
