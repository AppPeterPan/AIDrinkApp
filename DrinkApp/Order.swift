//
//  Order.swift
//  Demo
//
//  Created by Peter Pan on 2023/8/8.
//

import Foundation

struct Order: Codable, Identifiable {
    var id: String?  // This is now the unique identifier for Identifiable
    struct Fields: Codable {
        let sugar: String
        let ice: String
        let orderer: String
        let drink: String
        var size: String
    }
    
    var createdTime: String?
    var fields: Fields
}


struct OrdersResponse: Codable {
    let records: [Order]
    let offset: String?
}
