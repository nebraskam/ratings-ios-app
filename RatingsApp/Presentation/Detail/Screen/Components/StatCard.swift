//
//  StatCard.swift
//  RatingsApp
//
//  Created by Nebraska Melendez on 27/2/26.
//

import SwiftUI

struct StatCard: View {
    let label: String
    let value: Int
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Spacer()
            Text(String(value))
                .font(.title3)
                .fontWeight(.black)
                .fontDesign(.rounded)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary.opacity(0.05), lineWidth: 1)
        )
    }
}
