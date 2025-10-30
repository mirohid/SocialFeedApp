//
//  SocialFeedAppApp.swift
//  SocialFeedApp
//
//  Created by Mir Ohid Ali  on 29/10/25.
//

import SwiftUI
import CoreData

@main
struct SocialFeedAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
