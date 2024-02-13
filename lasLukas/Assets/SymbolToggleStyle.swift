//
//  ToggleView.swift
//  lasLukas
//
//  Created by Geovanny Valdes on 19/09/23.
//

import SwiftUI

struct SymbolToggleStyle: ToggleStyle {
    
    var systemImage: String = "checkmark"
    var activeColor: Color = .green
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            
            Spacer()
            
            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : Color(.black35))
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(3)
                        .overlay {
                            Image(systemName: systemImage)
                                .foregroundColor(configuration.isOn ? activeColor : Color(.black35))
                                .font(.title)
                        }
                        .rotationEffect(.degrees(configuration.isOn ? 0 : -180))
                        .offset(x: configuration.isOn ? 10 : -10)
                    
                }
                .frame(width: 50, height: 32)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

#Preview {
    ToggleView()
}
