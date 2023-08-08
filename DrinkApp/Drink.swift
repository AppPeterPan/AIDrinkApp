//
//  Drink.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/8/8.
//

import Foundation

struct Drink: Codable, Identifiable {
    var id: String { name }
    let name: String
    let description: String
    let price: [String: Int]
}
