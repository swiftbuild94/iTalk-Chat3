//
//  iTalk_ChatApp.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 27/03/2022.
//

import SwiftUI

@main
struct iTalk_ChatApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
