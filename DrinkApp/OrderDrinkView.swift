//
//  OrderDrinkView.swift
//  DrinkApp
//
//  Created by Peter Pan on 2023/8/8.
//

import SwiftUI

@MainActor
struct OrderDrinkView: View {
    @ObservedObject var viewModel: DrinkOrderViewModel
    var existingOrder: Order?
    
    @State private var selectedDrinkIndex = 0
    @State private var selectedSugarIndex = 0
    @State private var selectedIceIndex = 0
    @State private var orderer = ""
    @State private var size = "m"  // default to medium size
    
    let sugarOptions = ["正常", "少糖", "半糖", "微糖", "無糖"]
    let iceOptions = ["正常", "少冰", "微冰", "去冰"]
    
    // Alert state
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var currentDrinkSizeOptions: [String] {
        return Array(viewModel.drinks[selectedDrinkIndex].price.keys)
    }
    
    init(viewModel: DrinkOrderViewModel, existingOrder: Order? = nil) {
        self.viewModel = viewModel
        self.existingOrder = existingOrder
        
        // If an existing order is provided, use its values as defaults
        if let order = existingOrder {
            _selectedDrinkIndex = State(initialValue: viewModel.drinks.firstIndex { $0.name == order.fields.drink } ?? 0)
            _orderer = State(initialValue: order.fields.orderer)
            _size = State(initialValue: order.fields.size)
            _selectedSugarIndex = State(initialValue: sugarOptions.firstIndex(of: order.fields.sugar) ?? 0)
            _selectedIceIndex = State(initialValue: iceOptions.firstIndex(of: order.fields.ice) ?? 0)
        }
    }
    
    var body: some View {
        if !viewModel.drinks.isEmpty {
            VStack(spacing: 20) {
                Picker("Select Drink", selection: $selectedDrinkIndex) {
                    ForEach(viewModel.drinks.indices, id: \.self) { index in
                        Text(viewModel.drinks[index].name).tag(index)
                    }
                }
                TextField("Orderer Name", text: $orderer)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                Picker("Size", selection: $size) {
                    ForEach(currentDrinkSizeOptions, id: \.self) { sizeOption in
                        Text(sizeOption.uppercased()).tag(sizeOption)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Sugar Level", selection: $selectedSugarIndex) {
                    ForEach(0..<sugarOptions.count, id:\.self) { index in
                        Text(sugarOptions[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker("Ice Level", selection: $selectedIceIndex) {
                    ForEach(0..<iceOptions.count, id:\.self) { index in
                        Text(iceOptions[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button("Confirm") {
                    let order = Order(fields: Order.Fields(sugar: sugarOptions[selectedSugarIndex], ice: iceOptions[selectedIceIndex], orderer: orderer, drink: viewModel.drinks[selectedDrinkIndex].name, size: size))
                    Task {
                        do {
                            if let existingOrder = existingOrder {
                                try await viewModel.updateOrder(orderId: existingOrder.id ?? "", order: order)
                                alertTitle = "Success"
                                alertMessage = "Order updated successfully."
                            } else {
                                try await viewModel.createOrder(order: order)
                                alertTitle = "Success"
                                alertMessage = "Order created successfully."
                            }
                        } catch {
                            alertTitle = "Error"
                            alertMessage = "An error occurred while processing your request."
                        }
                        showAlert = true
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
            }
            .padding()
        }
       
    }
}


#Preview {
    OrderDrinkView(viewModel: DrinkOrderViewModel())
}
