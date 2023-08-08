//
//  DrinkOrderViewModel.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/8/8.
//

import Foundation

@MainActor
class DrinkOrderViewModel: ObservableObject {
    @Published var drinks: [Drink] = []
    @Published var orders: [Order] = []
    
    init() {
        Task {
            await fetchMenu()
        }
    }
    
    func fetchMenu() async {
        let menuURL = URL(string: "https://raw.githubusercontent.com/AppPeterPan/kebuke/main/menu.json")!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: menuURL)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            self.drinks = try decoder.decode([Drink].self, from: data)
        } catch {
            print("Failed to fetch the menu: \(error)")
        }
    }
    
    func fetchOrders() async {
        do {
            orders = try await OrderController.shared.fetchOrders()
        } catch {
            // Handle the error
            print("Failed to fetch orders: \(error)")
        }
    }
    
    func createOrder(order: Order) async throws {
        
        let newOrder = try await OrderController.shared.createOrder(order)
        orders.append(newOrder)
        
    }
    
    func updateOrder(orderId: String, order: Order) async throws {
        
        let updatedOrder = try await OrderController.shared.updateOrder(orderId, with: order)
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            orders[index] = updatedOrder
        }
        
    }
    
    func deleteOrder(orderId: String) async {
        do {
            let success = try await OrderController.shared.deleteOrder(orderId)
            if success {
                orders.removeAll { $0.id == orderId }
            }
        } catch {
            // Handle the error
            print("Failed to delete order: \(error)")
        }
    }
}
