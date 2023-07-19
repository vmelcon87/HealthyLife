//
//  RecipeUI.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 22/6/22.
//

import Foundation
import UIKit

// Helper entity to create some test data
struct RecipeUI: Hashable {
    var id: UUID
    var recipeName: String
    var modifDate: Date
    var kcal: Int16
    var rating: Int16
    var ingredients: String
    var preparation: String
    var prepTime: Int16
    var author: String
    var image: Data?
    
    init() {
        self.id = UUID()
        self.recipeName = ""
        self.modifDate = Date.now
        self.kcal = 0
        self.rating = 1
        self.ingredients = ""
        self.preparation = ""
        self.prepTime = 0
        self.author = ""
        self.image = Data()
    }
    
    init(id: UUID, recipeName: String, modifDate: Date, kcal: Int16, rating: Int16, ingredients: String, preparation: String, prepTime: Int16, author: String, image: Data) {
        self.id = id
        self.recipeName = recipeName
        self.modifDate = modifDate
        self.kcal = kcal
        self.rating = rating
        self.ingredients = ingredients
        self.preparation = preparation
        self.prepTime = prepTime
        self.author = author
        self.image = image
    }
    
    init(recipe: Recipe) {
        self.id = recipe.id!
        self.recipeName = recipe.recipeName!
        self.modifDate = recipe.modifDate!
        self.kcal = recipe.kcal
        self.rating = recipe.rating
        self.ingredients = recipe.ingredients!
        self.preparation = recipe.preparation!
        self.prepTime = recipe.prepTime
        self.author = recipe.author!
        self.image = recipe.image != nil ? recipe.image! : Data()
    }
    
    func asDBRecipe(fetchedRecipe: Recipe) -> Recipe {
        fetchedRecipe.id = self.id
        fetchedRecipe.recipeName = self.recipeName
        fetchedRecipe.modifDate = self.modifDate
        fetchedRecipe.kcal = self.kcal
        fetchedRecipe.rating = self.rating
        fetchedRecipe.ingredients = self.ingredients
        fetchedRecipe.preparation = self.preparation
        fetchedRecipe.prepTime = self.prepTime
        fetchedRecipe.author = self.author
        fetchedRecipe.image = self.image
        
        return fetchedRecipe
    }
}
