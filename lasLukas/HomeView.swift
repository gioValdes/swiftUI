//
//  HomeView.swift
//  swiftUITest
//
//  Created by Geovanny Valdes on 3/08/23.
//

import SwiftUI


struct HomeView: View {
    @State var showBills = false
    @State var showPleasure = false
    @State var showSavings = false
    
    
    var modelBills = ModelCard(
        colorsBG: [.cyan, .indigo],
        title: "Gastos",
        iconName: "checkmark.seal.fill",
        activeColor: Color("activeGreen"),
        currentYear: 1,
        currentMonth: 1
    )
    
    var modelPleasure = ModelCard(
        colorsBG: [.indigo, .purple],
        title: "Placer",
        iconName: "gamecontroller.fill",
        activeColor: Color("activeGreen"),
        currentYear: 1,
        currentMonth: 1
    )
    
    var modelSavings = ModelCard(
        colorsBG: [.purple, .teal],
        title: "Ahorro",
        iconName: "umbrella.fill",
        activeColor: Color("activeGreen"),
        currentYear: 1,
        currentMonth: 1
    )
    
    @State private var date = Date()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1)
        let endComponents = DateComponents(year: 2023, month: 12)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        
        VStack {
            
            let isOpen = showBills || showPleasure || showSavings
            
            VStack {
                
                DatePicker(
                    "",
                    selection: $date,
                    in: dateRange,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .clipped()
                .labelsHidden()
                .accentColor(Color.black)
                .frame(width: 120, alignment: .trailing)
                .disabled(isOpen)
                
                Text(15000000, format: .currency(code: "COP"))
                    .font( isOpen ? .caption : .title)
            }
            
            
            ScrollViewReader {value in
                ScrollView{
                    ExpensesItemView(show: $showBills, model: modelBills)
                        .id(Cards.bills)
                        .padding(5)
                    
                    ExpensesItemView(show: $showPleasure, model: modelPleasure)
                        .id(Cards.pleasure)
                        .padding(5)
                    
                    ExpensesItemView(show: $showSavings, model: modelSavings)
                        .id(Cards.savings)
                        .padding(5)
                }
            }
        }
        
    }
    
}

#Preview {
    HomeView()
}
