//
//  ExpensesItemView.swift
//  swiftUITest
//
//  Created by Geovanny Valdes on 1/08/23.
//
import UIKit
import SwiftUI
import Firebase

struct ExpensesItemView: View {
    @Binding var show: Bool
    @StateObject var model:ModelCard
    
    @State var percent = 0
    @State var stringTotal = 0
    @State var isEdit:Bool = false
    
    let db = Firestore.firestore()
    
    @State var itemCard : ModelItemCardFB = ModelItemCardFB()
    @State var itemCards = [ModelItemCardFB()]
    
    
    var body: some View {
        VStack {
            if show{
                HStack {
                    Spacer()
                    Image(systemName:"xmark.circle")
                        .onTapGesture {
                            withAnimation (.spring(response: 0.6, dampingFraction: 0.8)){
                                show = false
                            }
                        }
                    
                }.foregroundColor(.black)
                
                HStack {
                    Label(model.title, systemImage: "checkmark.seal.fill")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    let total = itemCards.map{Int($0.value) ?? 0}.reduce(0, +)
                    let percent = (total * 100)/15000
                    Text("\(percent)%")
                        .font(.headline)
                        .bold()
                }
                ScrollView{
                    let totalCount = $itemCards.count
                    ForEach(0...totalCount, id:\.self) { item in
                        HStack(alignment:.top){
                            if isEdit{
                                if itemCards.count > item
                                {
                                    TextEditor(text: $itemCards[item].description)
                                        .font(.callout)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    TextEditor( text: $itemCards[item].value)
                                        .font(.callout)
                                        .multilineTextAlignment(.trailing)
                                    Button {
                                        withAnimation (.spring(response: 0.6, dampingFraction: 0.8)){
                                            if itemCards.count > 0
                                            {
                                                let docRef = db.collection(model.title).document("test3").collection("items")
                                                
                                                docRef.document($itemCards[item].id ?? "").delete()
                                                itemCards.remove(at: item)
                                            }
                                            
                                        }
                                    } label: {
                                        Image(systemName: "trash.circle").font(.largeTitle).foregroundColor(.black)
                                    }
                                }
                            }else{
                                if itemCards.count > item
                                {
                                    TextField("", text: $itemCards[item].description)
                                        .font(.callout)
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    TextField("", text: $itemCards[item].value)
                                        .font(.callout)
                                        .multilineTextAlignment(.trailing)
                                    
                                    Toggle("", isOn: $itemCards[item].isPaid)
                                        .onChange(of: itemCards[item].isPaid) {
                                            let docRef = db.collection(model.title).document("test3").collection("items")
                                            
                                            docRef.document($itemCards[item].id ?? "").updateData(["isPaid" : itemCards[item].isPaid] )
                                        }
                                }
                            }
                        }
                        Divider()
                    }
                    Spacer(minLength: 30)
                    if isEdit{
                        Image(systemName: "plus.circle").font(.title)
                            .onTapGesture {
                                withAnimation (.spring(response: 0.6, dampingFraction: 0.8)){
                                    itemCards.append(ModelItemCardFB(value: "0", description: "", isPaid: false))
                                }
                            }
                    }else{
                        HStack {
                            Text("TOTAL")
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                            Spacer()
                            let total = itemCards.map{Int($0.value) ?? 0}.reduce(0, +)
                            
                            Text(total, format:.currency(code: "COP"))
                                .font(.callout)
                                .multilineTextAlignment(.trailing)
                            
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 100))
                    }
                }
                .frame(minHeight: 450)
                let buttonTitle:String = isEdit ? "Ok" : "Editar"
                Button(buttonTitle){
                    if isEdit{
                        for card in itemCards {
                            let docRef = db.collection(model.title).document("test3").collection("items")
                            
                            do {
                                if card.id == nil{
                                    try docRef.addDocument(from: card)
                                }else{
                                    try docRef.document(card.id ?? "").setData(from:card)
                                }
                                
                            } catch let error {
                                print("Error writing city to Firestore: \(error)")
                            }
                        }
                    }
                    withAnimation (.spring(response: 0.6, dampingFraction: 0.8)){
                        isEdit.toggle()
                    }
                }.buttonStyle(.borderedProminent)
                    .tint( .black)
            }else{
                HStack {
                    let total = itemCards.map{Int($0.value) ?? 0}.reduce(0, +)
                    Text(total, format:.currency(code: "COP"))
                        .font(.headline)
                        .bold()
                    Spacer()
                    Image(systemName:"slider.horizontal.3")
                        .onTapGesture {
                            withAnimation (.spring(response: 0.6, dampingFraction: 0.8)){
                                show = true
                            }
                        }
                }
                .foregroundColor(.black)
                
                
                HStack {
                    Label(model.title, systemImage: "checkmark.seal.fill")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                    Spacer()
                    let total = itemCards.map{Int($0.value) ?? 0}.reduce(0, +)
                    let percent = (total * 100)/15000
                    Text("\(percent)%")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(.linearGradient(Gradient(colors: model.colorsBG), startPoint: .topLeading, endPoint: .bottom), in: RoundedRectangle(cornerRadius: 20))
        .onAppear {
            
            db.collection("\(model.title)/test3/items")
                .addSnapshotListener { querySnapshot, err in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        itemCards.removeAll()
                        for document in querySnapshot!.documents {
                            do {
                                self.itemCard = try document.data(as: ModelItemCardFB.self)
                                itemCards.append(itemCard)
                            }
                            catch {
                                print(error)
                            }
                            
                        }
                    }
                }
        }
    }
    
}

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
    
    ExpensesItemView(show: .constant(false), model:
                        ModelCard(
                            colorsBG: [.cyan, .indigo],
                            title: "Gastos", iconName: "",
                            activeColor: .green,
                            currentYear: 1,
                            currentMonth: 1
                        ))
}
