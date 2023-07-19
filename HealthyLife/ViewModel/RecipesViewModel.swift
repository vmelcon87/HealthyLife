//
//  RecipesViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 25/5/22.
//

import SwiftUI
import Combine
import CoreData

class RecipesViewModel: ObservableObject {

    var recipesList: [RecipeUI] = []
    @Published var filteredData: [RecipeUI] = []
    @Published var searchTxt = ""
    @Published var selectedRecipe: RecipeUI = .init(id: UUID(), recipeName: "", modifDate: Date(), kcal: 0, rating: 1, ingredients: "", preparation: "", prepTime: 0, author: "", image: Data())
    @Published var ingredientList: [RecipeContentData] = []
    @Published var recipeSteps: [RecipeContentData] = []
    // Show image slector
    @Published var isImagePickerVisible = false
    // Check if edition mode activated
    @Published var isEditionMode = false
    var published: AnyCancellable?
    // Default Source type
    var sourceType: ImagePicker.SourceType = .camera
    // Check if user wants to create a new recipe
    var isNewRecipe = false
    // Get viewcontext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    // init basic data
    func initData(recipe: RecipeUI?) {
        if let safeRecipe = recipe {
            selectedRecipe = safeRecipe
        }
        else {
            selectedRecipe = .init(id: UUID(), recipeName: "", modifDate: Date(), kcal: 0, rating: 1, ingredients: "", preparation: "", prepTime: 0, author: "", image: Data())
            isNewRecipe = true
        }
        fetchRecipeIngredients()
        fetchRecipePrepSteps()
    }
    
    // Reset no data when user tap back button
    func resetData() {
        selectedRecipe = .init(id: UUID(), recipeName: "", modifDate: Date(), kcal: 0, rating: 1, ingredients: "", preparation: "", prepTime: 0, author: "", image: Data())
        fetchRecipeIngredients()
        fetchRecipePrepSteps()
        isNewRecipe = false
        isEditionMode = false
    }
    
    // Filter recipes by user searchbox input
    func filterDataSearch() {
        published = $searchTxt
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (str) in
                // Check search box empty
                if !self.searchTxt.isEmpty {
                    self.filteredData = self.recipesList
                        .filter{ $0.recipeName.lowercased().contains(str.lowercased()) }
                }
                else {
                    self.filteredData = self.recipesList
                }
            })
    }
    
    // MARK: - Ingredients, Preparation Management
    
    // Add new ingredient to recipe
    func addNewIngredientToRecipe(ingredient: String) {
        // Start checking if we have ingredients on list
        var lastIngredientID = 1
        if let safeID = ingredientList.last?.id {
            lastIngredientID = safeID + 1
        }
        // Create new ingredient with correct id
        let newIngredient = RecipeContentData(id: lastIngredientID, content: ingredient)
        ingredientList.append(newIngredient)
        // Encode ingredient to recipe ingredients
        let data = try? JSONEncoder().encode(ingredientList)
        selectedRecipe.ingredients = String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    // Remove selected ingredient from list
    func removeIngredientFromRecipe(ingredient: RecipeContentData) {
        if let ingredientIndex = ingredientList.firstIndex(where: { $0.id == ingredient.id }) {
            ingredientList.remove(at: ingredientIndex)
        }
        // Reorder ingredient list index
        for index in 0..<ingredientList.count {
            ingredientList[index].id = index + 1
        }
        // Encode ingredient to recipe ingredients
        let data = try? JSONEncoder().encode(ingredientList)
        selectedRecipe.ingredients = String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    // Add new rule to recipe
    func addNewRuleToRecipe(rule: String) {
        // Start checking if we have rules on list
        var lastRuleID = 1
        if let safeID = recipeSteps.last?.id {
            lastRuleID = safeID + 1
        }
        // Create new rule with correct id
        let newRule = RecipeContentData(id: lastRuleID, content: rule)
        recipeSteps.append(newRule)
        // Encode rule to recipe preparation
        let data = try? JSONEncoder().encode(recipeSteps)
        selectedRecipe.preparation = String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    // Remove selected rule from recipe steps
    func removeRuleFromRecipe(rule: RecipeContentData) {
        if let ruleIndex = recipeSteps.firstIndex(where: { $0.id == rule.id }) {
            recipeSteps.remove(at: ruleIndex)
        }
        // Reorder rule list index
        for index in 0..<recipeSteps.count {
            recipeSteps[index].id = index + 1
        }
        // Encode rule to recipe preparation
        let data = try? JSONEncoder().encode(recipeSteps)
        selectedRecipe.preparation = String(data: data!, encoding: String.Encoding.utf8)!
    }
    
    // Fetching recipe steps
    func fetchRecipePrepSteps() {
        let data = selectedRecipe.preparation.data(using: .utf8, allowLossyConversion: false)
        if let safeData = data, !safeData.isEmpty {
            recipeSteps = try! JSONDecoder().decode([RecipeContentData].self, from: data!)
        }
        else {
            recipeSteps = []
        }
    }
    
    // Convert recipe ingredients into an array
    func fetchRecipeIngredients() {
        let data = selectedRecipe.ingredients.data(using: .utf8, allowLossyConversion: false)
        if let safeData = data, !safeData.isEmpty {
            ingredientList = try! JSONDecoder().decode([RecipeContentData].self, from: data!)
        }
        else {
            ingredientList = []
        }
    }
    
    // MARK: - Basic Recipe CRUD
    
    // Fetch recipes from ddbb
    func fetchRecipes() {
        recipesList = []
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            // Fetch existing recipes
            let fetchedRecipess = try viewContext.fetch(fetchRequest)
            for recipe in fetchedRecipess {
                let auxRecipeUI = RecipeUI(recipe: recipe)
                recipesList.append(auxRecipeUI)
            }
        }
        catch {
            // No recipes found, set an empty list
            print("No Recipes found")
            recipesList = []
        }
        filteredData = recipesList
        
        // Init search box observer
        filterDataSearch()
    }
    
    // Save new recipe into DDBB
    func saveRecipeDDBB() {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", selectedRecipe.id as CVarArg)
        do {
            // Fetch existing recipes
            let recipes = try viewContext.fetch(fetchRequest)
            // Remove if exists
            if recipes.count > 0 {
                for object in recipes {
                    viewContext.delete(object)
                }
            }
            
        }
        catch {
            // No recipe found
            print("Failed to remove recipe")
        }
        
        // Prepare added recipe ingr
        let ingrData = try? JSONEncoder().encode(ingredientList)
        selectedRecipe.ingredients = String(data: ingrData!, encoding: String.Encoding.utf8)!
        // Prepare added recipe rules
        let ruleData = try? JSONEncoder().encode(recipeSteps)
        selectedRecipe.preparation = String(data: ruleData!, encoding: String.Encoding.utf8)!
        
        // Prepare new recipe to save into ddbb
        var recipeDDBB = Recipe(context: viewContext)
        recipeDDBB = selectedRecipe.asDBRecipe(fetchedRecipe: recipeDDBB)
        do {
            try viewContext.save()
        }
        catch {
            // No saved recipe
            print("Failed to save recipe")
        }
        fetchRecipes()
    }
    
    // Remove selected recipe from DDBB
    func removeSelectedRecipeDDBB(recipe: RecipeUI) {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id as CVarArg)
        do {
            // Fetch existing recipes
            let recipes = try viewContext.fetch(fetchRequest)
            // Remove if exists
            if recipes.count > 0 {
                for object in recipes {
                    viewContext.delete(object)
                }
                // Commit changes
                try viewContext.save()
            }
        }
        catch {
            // No recipe found
            print("Failed to remove recipe")
        }
        fetchRecipes()
    }
    
    // MARK: - Photo Management
    
    // Load photo library
    func choosePhoto() {
        sourceType = .photoLibrary
        isImagePickerVisible = true
    }
    
    // Take photo
    func takePhoto() {
        sourceType = .camera
        isImagePickerVisible = true
    }
    
    // User picks one image
    func didSelectImage(_ image: UIImage?) {
        // Set new image to selected recipe
        if let safeImage = image {
            let selectedImage = safeImage.jpegData(compressionQuality: 1.0)
            selectedRecipe.image = selectedImage!
        }
        isImagePickerVisible = false
    }
    
    // MARK: - Test Data
    
    // Fetch Test data
    func fetchTestData() {
        if recipesList.count == 0 {
            recipesList = []
            // Recipe example
            let imageData = UIImage(named: "tortillaPatatas")
            let image = imageData!.jpegData(compressionQuality: 1.0)
            let ingredients: String = "[{\"id\" : 1, \"content\" : \"3 Eggs\"}, {\"id\" : 2, \"content\" : \"4 potatoes\"}]"
            let preparation: String = "[{\"id\" : 1, \"content\" : \"Add olive oil to a 10 or 12 inch skillet over medium heat\"}, {\"id\" : 2, \"content\" : \"Add sliced potato and onion to the pan; they should be mostly covered with olive oil\"}]"
            
            let recipe = RecipeUI(id: UUID(), recipeName: "Tortilla de Patatas", modifDate: Date(), kcal: 417, rating: 8, ingredients: ingredients, preparation: preparation, prepTime: 75, author: "Victor Melcon", image: image!)
            recipesList.append(recipe)
        }
        filteredData = recipesList
        
        // Init search box observer
        filterDataSearch()
    }
    
    // Add new recipe to recipes list
    func saveRecipe() {
        if let recipeIndex = recipesList.firstIndex(where: {$0.id == selectedRecipe.id}) {
            recipesList.remove(at: recipeIndex)
        }
        // Prepare added recipe ingr
        let ingrData = try? JSONEncoder().encode(ingredientList)
        selectedRecipe.ingredients = String(data: ingrData!, encoding: String.Encoding.utf8)!
        // Prepare added recipe rules
        let ruleData = try? JSONEncoder().encode(recipeSteps)
        selectedRecipe.preparation = String(data: ruleData!, encoding: String.Encoding.utf8)!
        // Finally add recipe to list
        recipesList.append(selectedRecipe)
    }
    
    // Remove selected recipe fom list
    func removeSelectedRecipe(recipe: RecipeUI) {
        if let index = recipesList.firstIndex(of: recipe) {
            recipesList.remove(at: index)
        }
        filteredData = recipesList
    }
}


