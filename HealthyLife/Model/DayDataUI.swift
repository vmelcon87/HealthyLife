//
//  DayDataUI.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 25/6/22.
//

import Foundation

struct DayDataUI: Hashable {
    var id: UUID
    var date: Date
    var type: KindDayType
    var recipeList: [RecipeUI]
    var fitnessList: [FitnessUI]
    var itemList: [UUID]
    
    init() {
        self.id = UUID()
        self.date = Date()
        self.type = .breakfast
        self.recipeList = []
        self.fitnessList = []
        self.itemList = []
    }
    
    init(dayData: DayData) {
        self.id = dayData.id!
        self.date = dayData.date!
        self.type = dayData.type
        
        // Start converting recipes
        var recipeArray: [RecipeUI] = []
        for recipe in dayData.recipesList {
            let recipeUI = RecipeUI(recipe: recipe)
            recipeArray.append(recipeUI)
        }
        self.recipeList = recipeArray
        
        // Start converting fitness
        var fitnessArray: [FitnessUI] = []
        for fitness in dayData.fitnessList {
            let fitnessUI = FitnessUI(fitness: fitness)
            fitnessArray.append(fitnessUI)
        }
        self.fitnessList = fitnessArray
        
        self.itemList = []
    }
}

@objc
public enum KindDayType: Int16 {
    case breakfast
    case morningSnack
    case lunch
    case afternoonSnack
    case dinner
    case cardio
    case musculation
}
