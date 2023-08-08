//
//  OrdersListView.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/8/8.
//

import SwiftUI

struct OrdersListView: View {
    @ObservedObject var viewModel: DrinkOrderViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.orders) { order in
                    NavigationLink(destination: OrderDrinkView(viewModel: viewModel, existingOrder: order)) {
                        VStack(alignment: .leading) {
                            Text(order.fields.drink).font(.headline)
                            Text("Orderer: \(order.fields.orderer)")
                            Text("Size: \(order.fields.size.uppercased())")
                            Text("Sugar: \(order.fields.sugar)")
                            Text("Ice: \(order.fields.ice)")
                        }
                    }
                }
                .onDelete(perform: deleteOrder)
            }
            .navigationTitle("Orders")
            .toolbar {
                EditButton()
            }
            .onAppear {
                Task {
                    await viewModel.fetchOrders()
                }
            }
        }
    }

    private func deleteOrder(at offsets: IndexSet) {
        for index in offsets {
            let orderId = viewModel.orders[index].id ?? ""
            Task {
                await viewModel.deleteOrder(orderId: orderId)
            }
        }
    }
}



#Preview {
    OrdersListView(viewModel: DrinkOrderViewModel())
}
