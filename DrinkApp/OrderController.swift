//
//  DrinkController.swift
//  Demo
//
//  Created by Peter Pan on 2023/8/7.
//

import Foundation

class OrderController {
    enum DrinkControllerError: Error, LocalizedError {
        case ordersNotFound
        case orderCreationFailed
        case orderUpdateFailed
        case orderDeletionFailed
    }
    
    static let shared = OrderController()
    
    let baseURL = URL(string: "https://api.airtable.com/v0/appLp4DSjFqNdA7YT/")!
    let apiToken = "pate4JNrlSIHs8Nt0.544ea240d392be8e5228c603c354bb91c7f998b1cdd8eba166fc40596cab39b7" // Replace this with your actual API token.
    
    func fetchOrders() async throws -> [Order] {
        let ordersURL = baseURL.appendingPathComponent("Drink")
        var request = URLRequest(url: ordersURL)
        request.httpMethod = "GET"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DrinkControllerError.ordersNotFound
        }
        
        let decoder = JSONDecoder()
        let ordersResponse = try decoder.decode(OrdersResponse.self, from: data)

        return ordersResponse.records
    }
    
    func createOrder(_ order: Order) async throws -> Order {
        let orderURL = baseURL.appendingPathComponent("Drink")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(order)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DrinkControllerError.orderCreationFailed
        }
        
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(Order.self, from: data)

        return orderResponse
    }
    
    func updateOrder(_ orderId: String, with order: Order) async throws -> Order {
        let orderURL = baseURL.appendingPathComponent("Drink/\(orderId)")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "PATCH"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(order)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DrinkControllerError.orderUpdateFailed
        }
        
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(Order.self, from: data)

        return orderResponse
    }
    
    func deleteOrder(_ orderId: String) async throws -> Bool {
        let orderURL = baseURL.appendingPathComponent("Drink/\(orderId)")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DrinkControllerError.orderDeletionFailed
        }
        
        return true
    }
}

