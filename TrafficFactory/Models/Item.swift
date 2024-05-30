//
//  Item.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//


import Foundation

struct Item: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let imageURL: String

    enum CodingKeys: CodingKey {
        case title
        case description
        case imageURL
    }
}
