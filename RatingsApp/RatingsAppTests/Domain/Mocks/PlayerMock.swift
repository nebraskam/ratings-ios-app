//
//  PlayerMock.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 27/2/26.
//

import Foundation
@testable import RatingsApp

extension Player {
    static func mock(id: Int, name: String = "First") -> Player {
        Player(
            id: id,
            rank: id,
            firstName: name,
            lastName: "Last",
            commonName: nil,
            overallRating: 90,
            position: "ST",
            avatarUrl: "",
            shieldUrl: nil,
            pace: 90,
            shooting: 90,
            passing: 90,
            dribbling: 90,
            defending: 50,
            physical: 80
        )
    }
}
