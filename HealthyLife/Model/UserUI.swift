//
//  UserUI.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 22/6/22.
//

import Foundation

// Helper UI Class
class UserUI {
    var id: UUID
    var gender: String
    var birthday: Date
    var weight: Int16
    var height: Int16
    
    init() {
        self.id = UUID()
        self.gender = "Male"
        self.birthday = Date.now
        self.weight = 75
        self.height = 172
    }
    
    init(user: User) {
        self.id = user.id!
        self.gender = user.gender!
        self.birthday = user.birthday!
        self.weight = user.weight
        self.height = user.height
    }
    
    init(id: UUID, gender: String, birthday: Date, weight: Int16, height: Int16) {
        self.id = id
        self.gender = gender
        self.birthday = birthday
        self.weight = weight
        self.height = height
    }
    
    func asDBUser(fetchedUser: User) -> User {
        fetchedUser.id = self.id
        fetchedUser.gender = self.gender
        fetchedUser.birthday = self.birthday
        fetchedUser.weight = self.weight
        fetchedUser.height = self.height
        
        return fetchedUser
    }
}
