//
//  DashboardViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 23/5/22.
//

import SwiftUI
import CoreData

class DashboardViewModel: ObservableObject {
    
    // Update current week text shown in week selector
    @Published var currentWeekText: String = ""
    @Published var currentWeekDays: [String] = []
    @Published var currentWeekNames: [String] = []
    
    // Save complete current week days
    @Published var currentDateWeekDays: [Date] = []
    // Get day daydata for current week
    var fetchedDayData: [DayData] = []
    // Get viewcontext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    // Construct
    init() {
        
    }
    
    // Fetch current week day data
    func fetchCurrentWeekData() {
        let startDate = currentDateWeekDays.first
        let endDate = currentDateWeekDays.last
        
        let fetchedDays: NSFetchRequest<DayData> = DayData.fetchRequest()
        fetchedDays.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as CVarArg, endDate! as CVarArg)
        
        do {
            fetchedDayData = try viewContext.fetch(fetchedDays)
            for object in fetchedDayData {
                print("\(object.date!) - \(object.type)")
            }
        }
        catch {
            print("Cannot fetch date for current week")
        }
    }
    
    // From current day and current type, return correct color for calendar
    func getDayColorData(currentDay: Date, type: KindDayType) -> Color {
        let result = fetchedDayData.filter { $0.date == currentDay && $0.type == type }
        // Check for results
        if result.count > 0 {
            // I any list contains items, change to green
            if result.first!.recipesList.count > 0 || result.first!.fitnessList.count > 0 {
                return Color.green
            }
            else {
                return Color.gray
            }
        }
        else {
            return Color.gray
        }
    }
    
    // Get current week and format for calendar days
    func getCurrentWeek(currentDate: Date) {
        // Get device calendar, start on monday
        let calendar = Calendar.current
        
        // Init formatter to get only days from dates
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        
        let today = calendar.startOfDay(for: currentDate)
        // Get day of week, no matter if calendar start on sunday or monday
        let dayOfWeek = calendar.ordinality(of: .weekday, in: .weekOfYear, for: today)!
        currentDateWeekDays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
            // Create a non nil date array with week days
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }

        // Create string week days
        currentWeekDays = currentDateWeekDays
            .map { formatter.string(from: $0) }
        
        // Save current week day names
        formatter.dateFormat = "EEEE"
        currentWeekNames = currentDateWeekDays
            .map { formatter.string(from: $0) }

        // New format for first and last day of the week
        formatter.dateFormat = "dd MMM yyyy"
        currentWeekText = formatter.string(from: currentDateWeekDays.first!) + " - " + formatter.string(from: currentDateWeekDays.last!)
    }
    
    // Advance to next week data
    func goToNextWeek() {
        // Get last day of the week and add 1
        let lastDay = currentDateWeekDays.last
        let nextWeekDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDay!)!
        getCurrentWeek(currentDate: nextWeekDay)
        fetchCurrentWeekData()
    }
    
    // Return to previous week data
    func goToPreviousWeek() {
        // Get first day of the week and substract 1
        let firstDay = currentDateWeekDays.first
        let nextWeekDay = Calendar.current.date(byAdding: .day, value: -1, to: firstDay!)!
        getCurrentWeek(currentDate: nextWeekDay)
        fetchCurrentWeekData()
    }
}
