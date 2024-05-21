//
//  loginTaskProjectApp.swift
//  loginTaskProject
//
//  Created by Sumit Chandora on 20/05/24.
//

import SwiftUI

@main
struct loginTaskProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
