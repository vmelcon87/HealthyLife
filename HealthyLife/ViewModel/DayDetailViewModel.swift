//
//  DayDetailViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 15/6/22.
//

import SwiftUI
import Combine
import CoreData

class DayDetailViewModel: ObservableObject {
    @Published var allDayDateList: [DayDataUI] = []
    // All list for meals and exercises
    @Published var breakfastList: [RecipeUI] = []
    @Published var morningSnackList: [RecipeUI] = []
    @Published var lunchList: [RecipeUI] = []
    @Published var afternoonSnackList: [RecipeUI] = []
    @Published var dinner: [RecipeUI] = []
    @Published var cardioList: [FitnessUI] = []
    @Published var musculationList: [FitnessUI] = []
    
    // Store selected type to add to list
    var selectedItemType: KindDayType = .breakfast
    // Save selected day data
    var allDayData: [DayDataUI] = []
    
    // Aux list content
    var auxListData: [AuxModelData] = []
    @Published var filteredData: [AuxModelData] = []
    @Published var searchTxt = ""
    var published: AnyCancellable?
    // Saves actual date
    var selectedDate: Date = Date()
    
    // Get viewcontext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    // Set actual date
    func setActualDate(selectedDate: Date) {
        self.selectedDate = selectedDate
    }

    // Filter recipes by user searchbox input
    func filterDataSearch() {
        published = $searchTxt
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (str) in
                // Check search box empty
                if !self.searchTxt.isEmpty {
                    self.filteredData = self.auxListData
                        .filter{ $0.auxName.lowercased().contains(str.lowercased()) }
                }
                else {
                    self.filteredData = self.auxListData
                }
            })
    }
    
    // MARK: - CRUD Data
    
    // Fetching all day data
    func fetchDayData() {
        allDayData = []
        let fetchRequest: NSFetchRequest<DayData> = DayData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date == %@", self.selectedDate as CVarArg)
        do {
            // Fetch existing recipes
            let fetchedObject = try viewContext.fetch(fetchRequest)
            for object in fetchedObject {
                let objectUI = DayDataUI(dayData: object)
                allDayData.append(objectUI)
            }
        }
        catch {
            // No recipes found, set an empty list
            print("No day data found")
            allDayData = []
        }
        
        // Breakfast
        breakfastList = []
        let breakfastDay = allDayData.filter{ $0.type == .breakfast }
        if breakfastDay.count > 0 {
            breakfastList = breakfastDay.first!.recipeList
        }
        
        // Morning Snack
        morningSnackList = []
        let morningSnackDay = allDayData.filter{ $0.type == .morningSnack }
        if morningSnackDay.count > 0 {
            morningSnackList = morningSnackDay.first!.recipeList
        }
        
        // Lunch
        lunchList = []
        let lunchDay = allDayData.filter{ $0.type == .lunch }
        if lunchDay.count > 0 {
            lunchList = lunchDay.first!.recipeList
        }
        
        // Afternoon Snack
        afternoonSnackList = []
        let afternoonSnackDay = allDayData.filter{ $0.type == .afternoonSnack }
        if afternoonSnackDay.count > 0 {
            afternoonSnackList = afternoonSnackDay.first!.recipeList
        }
        
        // Dinner
        dinner = []
        let dinnerDay = allDayData.filter{ $0.type == .dinner }
        if dinnerDay.count > 0 {
            dinner = dinnerDay.first!.recipeList
        }
        
        // Cardio
        cardioList = []
        let cardioDay = allDayData.filter{ $0.type == .cardio }
        if cardioDay.count > 0 {
            cardioList = cardioDay.first!.fitnessList
        }
        
        // Musculation
        musculationList = []
        let musculationDay = allDayData.filter{ $0.type == .musculation }
        if musculationDay.count > 0 {
            musculationList = musculationDay.first!.fitnessList
        }
    }
    
    // Fetch aux list with data depending on selection item type
    func fetchAuxList() {
        auxListData = []
        // For cardio exercises parse list with needed data
        if selectedItemType == .cardio || selectedItemType == .musculation {
            let fetchRequest: NSFetchRequest<Fitness> = Fitness.fetchRequest()
            do {
                // Fetch existing recipes
                let fetchedFitness = try viewContext.fetch(fetchRequest)
                for fitness in fetchedFitness {
                    // Calculate correct type
                    let fitnessType = fitness.type == .cardio ? KindDayType.cardio : KindDayType.musculation
                    // Add to auxlist
                    let auxFitness = AuxModelData(id: fitness.id!, auxName: fitness.name!, type: fitnessType)
                    auxListData.append(auxFitness)
                }
                auxListData = auxListData.filter{ $0.type == selectedItemType }
            }
            catch {
                // No recipes found, set an empty list
                print("No Fitness found")
                auxListData = []
            }
        }
        else {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            do {
                // Fetch existing recipes
                let fetchedRecipes = try viewContext.fetch(fetchRequest)
                for recipe in fetchedRecipes {
                    let auxRecipe = AuxModelData(id: recipe.id!, auxName: recipe.recipeName!, type: .breakfast)
                    auxListData.append(auxRecipe)
                }
            }
            catch {
                // No recipes found, set an empty list
                print("No Recipes found")
                auxListData = []
            }
        }
        filteredData = auxListData
        
        // Init search box observer
        filterDataSearch()
    }
    
    // Detect item type and add to corresponding list
    func addSelectedItemType(selectedItem: AuxModelData) {
        let selDay = allDayData.filter{ $0.type == selectedItemType }
        
        // For fitness items
        if selectedItemType == .cardio || selectedItemType == .musculation {
            let fetchRequest: NSFetchRequest<Fitness> = Fitness.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", selectedItem.id as CVarArg)
            // Day data already in ddbb
            if selDay.count > 0 {
                let fetchDay: NSFetchRequest<DayData> = DayData.fetchRequest()
                fetchDay.predicate = NSPredicate(format: "id == %@", selDay.first!.id as CVarArg)
                do {
                    let fetchedDay = try viewContext.fetch(fetchDay)
                    let day = fetchedDay.first!
                    let fetchedFitness = try viewContext.fetch(fetchRequest)
                    for object in fetchedFitness {
                        day.addToFitness(object)
                    }
                    try viewContext.save()
                }
                catch {
                    // No recipes found, set an empty list
                    print("Cannot fetch fitness")
                }
            }
            // Need to add new day data
            else {
                let day = DayData(context: viewContext)
                day.id = UUID()
                day.date = self.selectedDate
                day.type = selectedItemType
                
                do {
                    let fetchedFitness = try viewContext.fetch(fetchRequest)
                    for object in fetchedFitness {
                        day.addToFitness(object)
                    }
                    try viewContext.save()
                }
                catch {
                    // No recipes found, set an empty list
                    print("Cannot save day")
                }
            }
        }
        // For recipe items
        else {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", selectedItem.id as CVarArg)
            // Day data already in ddbb
            if selDay.count > 0 {
                let fetchDay: NSFetchRequest<DayData> = DayData.fetchRequest()
                fetchDay.predicate = NSPredicate(format: "id == %@", selDay.first!.id as CVarArg)
                do {
                    let fetchedDay = try viewContext.fetch(fetchDay)
                    let day = fetchedDay.first!
                    let fetchedRecipe = try viewContext.fetch(fetchRequest)
                    for object in fetchedRecipe {
                        day.addToRecipes(object)
                    }
                    try viewContext.save()
                }
                catch {
                    // No recipes found, set an empty list
                    print("Cannot fetch recipe")
                }
            }
            // Need to add new day data
            else {
                let day = DayData(context: viewContext)
                day.id = UUID()
                day.date = self.selectedDate
                day.type = selectedItemType
                
                do {
                    let fetchedRecipe = try viewContext.fetch(fetchRequest)
                    for object in fetchedRecipe {
                        day.addToRecipes(object)
                    }
                    try viewContext.save()
                }
                catch {
                    // No recipes found, set an empty list
                    print("Cannot save day")
                }
            }
        }
        // Refresh list
        fetchDayData()
    }
    
    // Remove selected recipe from day
    func removeSelectedRecipeItem(selectedItem: RecipeUI) {
        // Get selected day
        let selDay = allDayData.filter{ $0.type == selectedItemType }
        let fetchDay: NSFetchRequest<DayData> = DayData.fetchRequest()
        fetchDay.predicate = NSPredicate(format: "id == %@", selDay.first!.id as CVarArg)
        // Get selected recipe
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", selectedItem.id as CVarArg)
        do {
            // Remove recipe from day
            let fetchedDay = try viewContext.fetch(fetchDay)
            let day = fetchedDay.first!
            let fetchedRecipe = try viewContext.fetch(fetchRequest)
            let recipe = fetchedRecipe.first!
            day.removeFromRecipes(recipe)
            try viewContext.save()
        }
        catch {
            print("Cannot remove recipe from day")
        }
        // Refresh list
        fetchDayData()
    }
    
    // Remove selected fitness from day
    func removeSelectedFitnessItem(selectedItem: FitnessUI) {
        // Get selected day
        let selDay = allDayData.filter{ $0.type == selectedItemType }
        let fetchDay: NSFetchRequest<DayData> = DayData.fetchRequest()
        fetchDay.predicate = NSPredicate(format: "id == %@", selDay.first!.id as CVarArg)
        // Get selected recipe
        let fetchRequest: NSFetchRequest<Fitness> = Fitness.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", selectedItem.id as CVarArg)
        do {
            // Remove recipe from day
            let fetchedDay = try viewContext.fetch(fetchDay)
            let day = fetchedDay.first!
            let fetchedFitness = try viewContext.fetch(fetchRequest)
            let fitness = fetchedFitness.first!
            day.removeFromFitness(fitness)
            try viewContext.save()
        }
        catch {
            print("Cannot remove fitness from day")
        }
        // Refresh list
        fetchDayData()
    }
    
    
    // MARK: - Test Data
    
    // Fetch test data
    func fetchTestData() {
        if breakfastList.count == 0 {
            breakfastList = []
            let recipe = RecipeUI(id: UUID(), recipeName: "Tortilla de Patatas", modifDate: Date(), kcal: 417, rating: 8, ingredients: "[{\"id\" : 1, \"content\" : \"3 Eggs\"}, {\"id\" : 2, \"content\" : \"4 potatoes\"}]", preparation: "[{\"id\" : 1, \"content\" : \"Add olive oil to a 10 or 12 inch skillet over medium heat\"}, {\"id\" : 2, \"content\" : \"Add sliced potato and onion to the pan; they should be mostly covered with olive oil\"}]", prepTime: 75, author: "Victor Melcon", image: UIImage(named: "tortillaPatatas")!.jpegData(compressionQuality: 1.0)!)
            breakfastList.append(recipe)
            
            musculationList = []
            let fitness = FitnessUI(id: UUID(), name: "Press de banca", modifDate: Date(), type: .musculation, reps: 10, weight: 25, time: 0)
            musculationList.append(fitness)
        }
    }
    
    // Fetch aux list with data depending on selection item type
    func fetchAuxListData() {
        // For cardio exercises parse list with needed data
        if selectedItemType == .cardio || selectedItemType == .musculation {
            let fitness = FitnessUI(id: UUID(), name: "Carrera", modifDate: Date(), type: .cardio, reps: 0, weight: 0, time: 25)
            let auxFitness = AuxModelData(id: fitness.id, auxName: fitness.name, type: .cardio)
            auxListData.append(auxFitness)
        }
        else {
            let recipe = RecipeUI(id: UUID(), recipeName: "Tortilla de Patatas", modifDate: Date(), kcal: 417, rating: 8, ingredients: "[{\"id\" : 1, \"content\" : \"3 Eggs\"}, {\"id\" : 2, \"content\" : \"4 potatoes\"}]", preparation: "[{\"id\" : 1, \"content\" : \"Add olive oil to a 10 or 12 inch skillet over medium heat\"}, {\"id\" : 2, \"content\" : \"Add sliced potato and onion to the pan; they should be mostly covered with olive oil\"}]", prepTime: 75, author: "Victor Melcon", image: UIImage(named: "tortillaPatatas")!.jpegData(compressionQuality: 1.0)!)
            let auxRecipe = AuxModelData(id: recipe.id, auxName: recipe.recipeName, type: .breakfast)
            auxListData.append(auxRecipe)
        }
        filteredData = auxListData
        
        // Init search box observer
        filterDataSearch()
    }
}

// Simple model to show data on auxList
struct AuxModelData: Hashable {
    let id: UUID
    var auxName: String
    var type: KindDayType
}
