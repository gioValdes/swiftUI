//
//  ContentView.swift
//  swiftUITest
//
//  Created by Geovanny Valdes on 13/06/23.
//

import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case home
    case calendar
    case stats
    
    var id: Self { self }
}

enum Cards:Hashable{
    case bills
    case pleasure
    case savings
}


struct ContentView: View {
    @State private var isChecked = false
    @State private var tab = Tab.home
    
    
    @Namespace var namespace
    
    
    var body: some View {
        //TOTAL
        TabView(selection: $tab) {
            VStack{
                //Calendar
            }
            .tabItem { Label(
                title: { Text("Agosto") },
                icon: { Image(systemName: "calendar") }
            ) }.tag(Tab.calendar)
            
            
            HomeView()
                .tabItem { Label(
                    title: { Text("") },
                    icon: { Image(systemName: "house") }
                ) }.tag(Tab.home)
            
            VStack{
                //StatsPage
            }
            .tabItem { Label(
                title: { Text("") },
                icon: { Image(systemName: "chart.line.uptrend.xyaxis") }
            ) }.tag(Tab.stats)
                .background(.black)
        }
    }
}




#Preview {
    ContentView()
        .colorScheme(.dark)
        .background(Color.black)
}
