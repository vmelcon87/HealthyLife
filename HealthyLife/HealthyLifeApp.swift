//
//  HealthyLifeApp.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 19/5/22.
//

import SwiftUI

@main
struct HealthyLifeApp: App {
    let persistenceController = PersistenceController.shared
    let navViewModel: NavigationViewModel = .init()

    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(navViewModel)
                .preferredColorScheme(.light)
        }
    }
}
