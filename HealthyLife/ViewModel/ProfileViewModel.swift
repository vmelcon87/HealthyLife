//
//  ProfileViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 22/6/22.
//

import SwiftUI
import CoreData

class ProfileViewModel: ObservableObject {
    // Current user
    @Published var user: UserUI = .init()
    // Gender options
    @Published var genderOptions: [String] = ["Male", "Female"]
    // Get viewcontext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    var fetchedUser: User = User()
    
    // Fetch existing user
    func fetchUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            // Fetch existing user
            let existingUser = try viewContext.fetch(fetchRequest)
            if existingUser.count > 0 {
                fetchedUser = existingUser.first!
                user = UserUI(user: fetchedUser)
            }
            // No existing users
            else {
                fetchedUser = User(context: viewContext)
            }
        }
        catch {
            // No user found, create new user
            print("No User found, using default User")
            fetchedUser = User(context: viewContext)
        }
    }
    
    // Save user date
    func saveUser() {
        fetchedUser = user.asDBUser(fetchedUser: fetchedUser)
        do{
            try viewContext.save()
        }
        catch {
            print("Cannot save user into ddbb")
        }
    }
}
