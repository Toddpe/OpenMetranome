//
//  ContentView.swift
//  OpenMetranome
//
//  Created by Todd Pederson on 2/2/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State public var showingOptions = false
    
    // Tempo gesture:
    let maxTempo: Int = 300
    let gestureSpeed: Double = 0.3
    
    @State var value: Double = 120.0
    @State var valueInt: Int = 120
    @State private var startDragValue : Double = -1.0
    
    var body: some View {
        TabView{
            VStack{
                HStack{
                    Text("OpenMetronome")
                        .bold()
                        .font(.system(size: 20))
                        .padding(.leading)
                        .padding(.top, 5)
                    Spacer()
                    Button {
                        showingOptions = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    }
                        .popover(isPresented: $showingOptions) {
                            PopoverView(showingOptions: $showingOptions)
                        }
                        .font(.system(size: 20))
                        .padding(.trailing)
                        .padding(.top, 5)

                }
                Divider()
                Spacer()
                
                
                VStack{
                    Button {
                        if (valueInt < 300){
                            value += 1
                            valueInt += 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 30, weight: .regular, design: .default))
                            .foregroundColor(Color(.label))
                    }
                    Text("\(valueInt)")
                        .font(.system(size: 40, weight: .regular, design: .default))
                    Button {
                        if (valueInt > 0){
                            value -= 1
                            valueInt -= 1
                        }
                    } label: {
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.system(size: 30, weight: .regular, design: .default))
                            .foregroundColor(Color(.label))
                    }
                    
                }
                    .gesture(DragGesture(minimumDistance: 0)
                    .onEnded({ _ in
                        startDragValue = -1.0
                    })
                    .onChanged { dragValue in
                        let diff =  dragValue.startLocation.y - dragValue.location.y
                        if startDragValue == -1 {
                            startDragValue = value
                        }
                        let newValue = startDragValue + (Double(diff)*gestureSpeed)
                        value = newValue < 0 ? 0 : newValue > Double(maxTempo) ? Double(maxTempo) : newValue
                        valueInt = Int(value)
                    })
                    
                
                Spacer()
                
                // Background for TabView
                Rectangle()
                    .frame(height: 0)
                    .background(.thinMaterial)
            }
            .background(Color("Background"))
                .tabItem {
                    Image(systemName: "play")
                    Text("Metranome")
                }
            ZStack{
                Text("Second")
            }
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Library")
                }
            ZStack{
                Text("Third")
            }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct PopoverView: View{
    
    @Binding public var showingOptions: Bool
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Button {
                    showingOptions = false
                } label: {
                    Text("Done")
                        .padding([.top, .trailing])
                        .font(.system(size: 17, weight: .bold, design: .default))
                }
            }
            Divider()
            Spacer()
            Text("Settings go here")
                .font(.system(size: 17))
            Spacer()
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
