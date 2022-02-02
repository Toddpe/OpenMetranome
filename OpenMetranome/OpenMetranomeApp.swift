//
//  OpenMetranomeApp.swift
//  OpenMetranome
//
//  Created by Todd Pederson on 2/2/22.
//

import SwiftUI

@main
struct OpenMetranomeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
