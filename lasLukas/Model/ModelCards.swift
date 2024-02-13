//
//  ModelCards.swift
//  swiftUITest
//
//  Created by Geovanny Valdes on 4/08/23.
//

import SwiftUI
import FirebaseFirestoreSwift

public class CardType: ObservableObject, Identifiable {
    @Published var cardType: Cards = .bills
    
    init(cardType: Cards) {
        self.cardType = cardType
    }
}


public class ModelCard: ObservableObject, Identifiable {
    @Published var colorsBG: [Color] = []
    @Published var title: String = ""
    @Published var iconName: String = ""
    @Published var activeColor: Color = .black
    @Published var currentYear:Int = 1
    @Published var currentMonth:Int = 1
    
    init(colorsBG: [Color], title: String, iconName: String, activeColor: Color, currentYear:Int, currentMonth:Int) {
        self.colorsBG = colorsBG
        self.title = title
        self.iconName = iconName
        self.activeColor = activeColor
        self.currentYear = currentYear
        self.currentMonth = currentMonth
    }
}

public class ModelItemCard: ObservableObject, Identifiable {
    @Published var value: String = ""
    @Published var description: String = ""
    @Published var isPaid: Bool = false
    
    init(value: String, description: String, isPaid: Bool) {
        self.value = value
        self.description = description
        self.isPaid = isPaid
    }
    
}

struct ModelItemCardFB:Encodable, Decodable, Hashable, Identifiable {
    @DocumentID var id: String?
    var value: String = ""
    var description: String = ""
    var isPaid: Bool = false
    var name:String?
}
