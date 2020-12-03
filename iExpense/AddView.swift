//
//  AddView.swift
//  iExpense
//
//  Created by Waveline Media on 12/3/20.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @ObservedObject var expenses = Expenses()
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new Expense")
            .navigationBarItems(trailing: Button(action: {
                if let actualAmount = Int(self.amount) {
                    let newItem = ExpenseItem(
                        name: self.name,
                        type: self.type,
                        amount: actualAmount
                    )
                    self.expenses.items.append(newItem)
                }
            }, label: {
                Text("Save")
            }))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
