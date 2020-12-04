//
//  ContentView.swift
//  iExpense
//
//  Created by Waveline Media on 12/3/20.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let expenseItems = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: expenseItems) {
                self.items = decoded
                return
            }
        }
        
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                /* When adding 'Identifiable' protocol, the ForEach knows that the id property in struct is unique */
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .expenseNameStyle(color: self.getColor(expenseAmount: item.amount))
                            Text(item.type)
                        }
                        Spacer()
                        Text("$\(item.amount)")
                            .expenseAmountStyle(color: self.getColor(expenseAmount: item.amount))
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.showingAddExpense = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .sheet(isPresented: $showingAddExpense, content: {
                        AddView(expenses: self.expenses)
                    })
                    
                    EditButton()
                }
            )
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func getColor(expenseAmount: Int) -> Color {
        if expenseAmount <= 10 {
            return Color.yellow
        } else if expenseAmount <= 100 {
            return Color.orange
        }
        return Color.red
    }
}

extension Text {
    func expenseNameStyle(color: Color) -> some View {
        self
            .font(.headline)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .foregroundColor(color)
    }
    
    func expenseAmountStyle(color: Color) -> some View {
        self
            .fontWeight(.bold)
            .foregroundColor(color)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
