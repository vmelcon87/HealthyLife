//
//  FitnessUI.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 25/6/22.
//

import SwiftUI

// Tets entity to test data
struct FitnessUI: Hashable {
    var id: UUID
    var name: String
    var modifDate: Date
    var type: FitnessType
    var reps: Int16
    var weight: Int16
    var time: Int16
    
    init() {
        self.id = UUID()
        self.name = ""
        self.modifDate = Date()
        self.type = .cardio
        self.reps = 0
        self.weight = 0
        self.time = 0
    }
    
    init(fitness: Fitness) {
        self.id = fitness.id!
        self.name = fitness.name!
        self.modifDate = fitness.modifDate!
        self.type = fitness.type
        self.reps = fitness.reps
        self.weight = fitness.weight
        self.time = fitness.time
    }
    
    init(id: UUID, name: String, modifDate: Date, type: FitnessType, reps: Int16, weight: Int16, time: Int16) {
        self.id = id
        self.name = name
        self.modifDate = modifDate
        self.type = type
        self.reps = reps
        self.weight = weight
        self.time = time
    }
    
    func asDBRecipe(fetchedFitness: Fitness) -> Fitness {
        fetchedFitness.id = self.id
        fetchedFitness.name = self.name
        fetchedFitness.modifDate = self.modifDate
        fetchedFitness.type = self.type
        fetchedFitness.reps = self.reps
        fetchedFitness.weight = self.weight
        fetchedFitness.time = self.time
        
        return fetchedFitness
    }
}


@objc
public enum FitnessType: Int16 {
    case musculation
    case cardio
    case all
}
