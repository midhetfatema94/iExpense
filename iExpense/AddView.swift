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
    @State private var showValidationAlert = false
    @ObservedObject var expenses = Expenses()
    @Environment(\.presentationMode) var presentationMode
    
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
                if self.validateExpense() {
                    if let actualAmount = Int(self.amount) {
                        let newItem = ExpenseItem(
                            name: self.name,
                            type: self.type,
                            amount: actualAmount
                        )
                        self.expenses.items.append(newItem)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    self.showValidationAlert = true
                }
            }, label: {
                Text("Save")
            }))
            .alert(isPresented: $showValidationAlert) {
                Alert(title: Text("Validation Error"),
                      message: Text("Please enter the data correctly"),
                      dismissButton: .default(Text("Okay")) {
                        self.showValidationAlert = false
                })
            }
        }
    }
    
    func validateExpense() -> Bool {
        
        guard let amountInt = Int(amount) else { return false }
        
        if name.isEmpty {
            return false
        } else if amountInt <= 0 {
            return false
        }
        return true
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
