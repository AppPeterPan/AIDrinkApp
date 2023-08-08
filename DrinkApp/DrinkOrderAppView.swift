//
//  DrinkOrderAppView.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/8/8.
//

import SwiftUI

struct DrinkOrderAppView: View {
    @StateObject private var viewModel = DrinkOrderViewModel()

    var body: some View {
        TabView {
            OrderDrinkView(viewModel: viewModel)
                .tabItem {
                    Label("Order Drink", systemImage: "cart.fill")
                }
            
            OrdersListView(viewModel: viewModel)
                .tabItem {
                    Label("Orders List", systemImage: "list.bullet")
                }
        }
    }
}


#Preview {
    DrinkOrderAppView()
}
