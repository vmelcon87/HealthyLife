//
//  DayData+CoreDataProperties.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 25/6/22.
//
//

import Foundation
import CoreData


extension DayData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayData> {
        return NSFetchRequest<DayData>(entityName: "DayData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var type: KindDayType
    @NSManaged public var recipes: NSSet?
    @NSManaged public var fitness: NSSet?
    
    public var recipesList: [Recipe] {
        let recipeList = recipes as? Set<Recipe> ?? []
        return Array(recipeList)
    }
    
    public var fitnessList: [Fitness] {
        let fitnessList = fitness as? Set<Fitness> ?? []
        return Array(fitnessList)
    }

}

// MARK: Generated accessors for recipes
extension DayData {

    @objc(addRecipesObject:)
    @NSManaged public func addToRecipes(_ value: Recipe)

    @objc(removeRecipesObject:)
    @NSManaged public func removeFromRecipes(_ value: Recipe)

    @objc(addRecipes:)
    @NSManaged public func addToRecipes(_ values: NSSet)

    @objc(removeRecipes:)
    @NSManaged public func removeFromRecipes(_ values: NSSet)

}

// MARK: Generated accessors for fitness
extension DayData {

    @objc(addFitnessObject:)
    @NSManaged public func addToFitness(_ value: Fitness)

    @objc(removeFitnessObject:)
    @NSManaged public func removeFromFitness(_ value: Fitness)

    @objc(addFitness:)
    @NSManaged public func addToFitness(_ values: NSSet)

    @objc(removeFitness:)
    @NSManaged public func removeFromFitness(_ values: NSSet)

}

extension DayData : Identifiable {

}
