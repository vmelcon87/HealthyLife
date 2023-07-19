//
//  FitnessViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 26/5/22.
//

import Foundation
import Combine
import CoreData

class FitnessViewModel: ObservableObject {
    
    // Main data
    var fitnessList: [FitnessUI] = []
    // Filtered data for searchs
    @Published var filteredData: [FitnessUI] = []
    @Published var currentTab: String = "ALL"
    @Published var searchTxt: String = ""
    @Published var selectedFitness: FitnessUI = .init(id: UUID(), name: "", modifDate: Date(), type: .cardio, reps: 0, weight: 0, time: 0)
    // Check if edition mode activated
    @Published var isEditionMode = false
    var published: AnyCancellable?
    var selectedType: FitnessType = .all
    // Check if user wants to create a new fitness
    var isNewFitness = false
    // Get viewcontext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    
    // init basic data
    func initData(fitness: FitnessUI?) {
        if let safeFitness = fitness {
            selectedFitness = safeFitness
        }
        else {
            selectedFitness = .init(id: UUID(), name: "", modifDate: Date(), type: .cardio, reps: 0, weight: 0, time: 0)
            isNewFitness = true
        }
    }
    
    // Reset no data when user tap back button
    func resetData() {
        selectedFitness = .init(id: UUID(), name: "", modifDate: Date(), type: .cardio, reps: 0, weight: 0, time: 0)
        isNewFitness = false
        isEditionMode = false
    }
    
    // Filter data search using combine
    func filterDataSearch() {
        self.published = $searchTxt
            .receive(on: RunLoop.main)
            .sink(receiveValue: { (str) in
                // Perform search by type
                self.filterResultsByType()
            })
    }
    
    // Filter results by user selected filter
    func filterResultsByType() {
        switch currentTab.lowercased() {
        case "Musculation".lowercased():
            selectedType = .musculation
            // Evaluate if search box is empty
            if searchTxt.isEmpty {
                filteredData = fitnessList
                    .filter { $0.type == selectedType }
            }
            else {
                filteredData = fitnessList
                    .filter { $0.type == selectedType
                        && $0.name.lowercased().contains(searchTxt.lowercased())
                    }
            }
            break
            
        case "Cardio".lowercased():
            selectedType = .cardio
            // Evaluate if search box is empty
            if searchTxt.isEmpty {
                filteredData = fitnessList
                    .filter { $0.type == selectedType }
            }
            else {
                filteredData = fitnessList
                    .filter { $0.type == selectedType
                        && $0.name.lowercased().contains(searchTxt.lowercased())
                    }
            }
            break
            
        default:
            selectedType = .all
            // Evaluate if search box is empty
            if searchTxt.isEmpty {
                filteredData = fitnessList
            }
            else {
                filteredData = fitnessList
                    .filter { $0.name.lowercased().contains(searchTxt.lowercased())
                    }
            }
            
            break
        }
    }
    
    // MARK: - Basic CRUD
    
    // Fetch fitness available exercises
    func fetchFitness() {
        fitnessList = []
        let fetchRequest: NSFetchRequest<Fitness> = Fitness.fetchRequest()
        do {
            // Fetch existing recipes
            let fetchedFitness = try viewContext.fetch(fetchRequest)
            for fitness in fetchedFitness {
                let auxFitnessUI = FitnessUI(fitness: fitness)
                fitnessList.append(auxFitnessUI)
            }
        }
        catch {
            // No recipes found, set an empty list
            print("No Fitness found")
            fitnessList = []
        }
        
        filterResultsByType()
        // Prepare filter observer
        filterDataSearch()
    }
    
    // Save fitness data into ddbb
    func saveFitnessDDBB() {
        // Remove first existing item
        let fetchRequest: NSFetchRequest<Fitness> = Fitness.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", selectedFitness.id as CVarArg)
        do {
            // Fetch existing recipes
            let fitness = try viewContext.fetch(fetchRequest)
            // Remove if exists
            if fitness.count > 0 {
                for object in fitness {
                    viewContext.delete(object)
                }
            }
        }
        catch {
            // No recipe found
            print("Failed to remove fitness")
        }
        
        // Prepare new fitness to save into ddbb
        var fitnessDDBB = Fitness(context: viewContext)
        fitnessDDBB = selectedFitness.asDBRecipe(fetchedFitness: fitnessDDBB)
        do {
            try viewContext.save()
        }
        catch {
            // No saved recipe
            print("Failed to save new fitness")
        }
        fetchFitness()
    }
    
    // Remove selected fitness from ddbb
    func removeSelectedFitnessDDBB(fitness: FitnessUI) {
        let fetchRequest: NSFetchRequest<Fitness> = Fitness.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", fitness.id as CVarArg)
        do {
            // Fetch existing recipes
            let fitness = try viewContext.fetch(fetchRequest)
            // Remove if exists
            if fitness.count > 0 {
                for object in fitness {
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
        fetchFitness()
    }
    
    // MARK: - Test Data
    
    // Fetch test data
    func fectchTestData() {
        
        if fitnessList.count == 0 {
            fitnessList = []
            fitnessList.append(FitnessUI(id: UUID(), name: "Cinta", modifDate: Date(), type: .cardio, reps: 0, weight: 0, time: 30*60))
            fitnessList.append(FitnessUI(id: UUID(), name: "Press de banca", modifDate: Date(), type: .musculation, reps: 10, weight: 25, time: 0))
        }
        
        filterResultsByType()
        // Prepare filter observer
        filterDataSearch()
    }
    
    // Add new exercise to fitness list
    func saveFitness() {
        if let fitnessIndex = fitnessList.firstIndex(where: {$0.id == selectedFitness.id}) {
            fitnessList.remove(at: fitnessIndex)
        }
        // Finally add recipe to list
        fitnessList.append(selectedFitness)
    }
    
    // Remove selected fitness exercise fom list
    func removeSelectedFitness(fitness: FitnessUI) {
        if let index = fitnessList.firstIndex(of: fitness) {
            fitnessList.remove(at: index)
        }
        filteredData = fitnessList
    }
}

