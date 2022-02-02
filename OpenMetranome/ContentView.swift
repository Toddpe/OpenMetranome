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
                        // TODO: Add fullscreen modal
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                    }
                        .font(.system(size: 20))
                        .padding(.trailing)
                        .padding(.top, 5)

                }
                Divider()
                
                Spacer()
                Text("First")
                Spacer()
                
                // Background for TabView
                Rectangle()
                    .frame(height: 0)
                    .background(.thinMaterial)
            }
            .background(Color("Background"))
                .tabItem {
                    Image(systemName: "play")
                    Text("First")
                }
            ZStack{
                Text("Second")
            }
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Second")
                }
            ZStack{
                Text("Third")
            }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Third")
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
