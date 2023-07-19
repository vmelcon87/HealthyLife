//
//  SummaryViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 19/6/22.
//

import SwiftUI
import SwiftUICharts
import CoreData

class SummaryViewModel: ObservableObject {
    
    // Get eaten data
    @Published var eatenData: BarChartData?
    // Get fitness data
    @Published var fitnessData: BarChartData?
    
    // Save complete current week days
    var currentDateWeekDays: [Date] = []
    var currentWeekNames: [String] = []
    
    // Get day daydata for current week
    var fetchedDayData: [DayData] = []
    // Set default chat color
    let colorWeekData: [Color] = [.purple, .blue, .green, .yellow, .yellow, .orange, .red]
    // Save total recipe kcal
    @Published var totalRecipeKcal: Int16 = 0
    // Save total fitness kcal
    @Published var totalFitnessKcal: Int16 = 0
    // Save user profile
    var fetchedUser: User = User()
    
    // Get viewcontext
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    // Constructor
    init() {
        fetchUser()
        getCurrentWeek(currentDate: Date())
        fetchCurrentWeekData()
        eatenData = getWeekRecipeData()
        fitnessData = getWeekFitnessData()
    }
    
    // Get user data
    func fetchUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            // Fetch existing user
            let existingUser = try viewContext.fetch(fetchRequest)
            if existingUser.count > 0 {
                fetchedUser = existingUser.first!
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
    
    // Fetch current week day data
    func fetchCurrentWeekData() {
        let startDate = currentDateWeekDays.first
        let endDate = currentDateWeekDays.last
        
        let fetchedDays: NSFetchRequest<DayData> = DayData.fetchRequest()
        fetchedDays.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as CVarArg, endDate! as CVarArg)
        
        do {
            fetchedDayData = try viewContext.fetch(fetchedDays)
        }
        catch {
            print("Cannot fetch date for current week")
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
        
        // Save current week day names
        formatter.dateFormat = "E"
        currentWeekNames = currentDateWeekDays
            .map { formatter.string(from: $0) }
    }
    
    // Get current week recipe total kcal
    func getWeekRecipeData() -> BarChartData {
        var dataPoints: [BarChartDataPoint] = []
        var weekIndex = 0
        for weekDay in currentDateWeekDays {
            let dayData = fetchedDayData.filter { $0.date == weekDay }
            var totalKcal: Int16 = 0
            if dayData.count > 0 {
                for data in dayData {
                    for recipeData in data.recipesList {
                        totalKcal += recipeData.kcal
                    }
                }
            }
            let barData = BarChartDataPoint(value: Double(totalKcal), xAxisLabel: currentWeekNames[weekIndex]   , description: "Day Kcal"   , colour: ColourStyle(colour: colorWeekData[weekIndex]))
            dataPoints.append(barData)
            weekIndex += 1
            totalRecipeKcal += totalKcal
        }
        
        let data: BarDataSet =
        BarDataSet(dataPoints: dataPoints,
                   legendTitle: "Data")
        
        let metadata = ChartMetadata(title: "", subtitle: "")
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                  lineColour: Color(.lightGray).opacity(0.25),
                                  lineWidth: 1)
        
        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
                                       xAxisTitle: "Week days",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 5,
                                       yAxisTitle: "Kcal",
                                       baseline: .zero,
                                       topLine: .maximumValue)
        
        return BarChartData(dataSets: data,
                            metadata: metadata,
                            xAxisLabels: ["One"],
                            barStyle: BarStyle(barWidth: 0.7,
                                               cornerRadius: CornerRadius(top: 5, bottom: 0),
                                               colourFrom: .dataPoints,
                                               colour: ColourStyle(colour: .blue)),
                            chartStyle: chartStyle)
    }
    
    // Get current week recipe total kcal
    func getWeekFitnessData() -> BarChartData {
        var dataPoints: [BarChartDataPoint] = []
        var weekIndex = 0
        for weekDay in currentDateWeekDays {
            let dayData = fetchedDayData.filter { $0.date == weekDay }
            var totalKcal: Int16 = 0
            if dayData.count > 0 {
                for data in dayData {
                    for fitnessData in data.fitnessList {
                        if fitnessData.type == .cardio {
                            totalKcal += Int16(KcalHelper().calculateCalorieBurn(weight: Int(fetchedUser.weight), time: Int(fitnessData.time)))
                        }
                        else {
                            totalKcal += Int16(KcalHelper().calculateWeightBurn(weight: Int(fetchedUser.weight), repts: Int(fitnessData.reps)))
                        }
                    }
                }
            }
            let barData = BarChartDataPoint(value: Double(totalKcal), xAxisLabel: currentWeekNames[weekIndex]   , description: "Day Kcal"   , colour: ColourStyle(colour: colorWeekData[weekIndex]))
            dataPoints.append(barData)
            weekIndex += 1
            totalFitnessKcal += totalKcal
        }
        
        let data: BarDataSet =
        BarDataSet(dataPoints: dataPoints,
                   legendTitle: "Data")
        
        let metadata = ChartMetadata(title: "", subtitle: "")
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                  lineColour: Color(.lightGray).opacity(0.25),
                                  lineWidth: 1)
        
        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
                                       xAxisTitle: "Week days",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 5,
                                       yAxisTitle: "Kcal",
                                       baseline: .zero,
                                       topLine: .maximumValue)
        
        return BarChartData(dataSets: data,
                            metadata: metadata,
                            xAxisLabels: ["One"],
                            barStyle: BarStyle(barWidth: 0.7,
                                               cornerRadius: CornerRadius(top: 5, bottom: 0),
                                               colourFrom: .dataPoints,
                                               colour: ColourStyle(colour: .blue)),
                            chartStyle: chartStyle)
    }
    
    // MARK: - Test Data
    
    // Calculate week data
    func weekOfData() -> BarChartData {
        let data: BarDataSet =
        BarDataSet(dataPoints: [
            BarChartDataPoint(value: 200, xAxisLabel: "Mon"   , description: "Monday Kcal"   , colour: ColourStyle(colour: .purple)),
            BarChartDataPoint(value: 290 , xAxisLabel: "Tue"  , description: "Tuesday Kcal"  , colour: ColourStyle(colour: .blue)),
            BarChartDataPoint(value: 600, xAxisLabel: "Wed"    , description: "Wednesday Kcal"    , colour: ColourStyle(colour: .green)),
            BarChartDataPoint(value: 175, xAxisLabel: "Thu"   , description: "Thursday Kcal"   , colour: ColourStyle(colour: .yellow)),
            BarChartDataPoint(value: 260 , xAxisLabel: "Fri"   , description: "Friday Kcal"   , colour: ColourStyle(colour: .yellow)),
            BarChartDataPoint(value: 150, xAxisLabel: "Sat"  , description: "Saturday Kcal"  , colour: ColourStyle(colour: .orange)),
            BarChartDataPoint(value: 500, xAxisLabel: "Sun", description: "Sunday Kcal", colour: ColourStyle(colour: .red))
        ],
                   legendTitle: "Data")
        
        let metadata = ChartMetadata(title: "", subtitle: "")
        
        let gridStyle = GridStyle(numberOfLines: 7,
                                  lineColour: Color(.lightGray).opacity(0.25),
                                  lineWidth: 1)
        
        let chartStyle = BarChartStyle(infoBoxPlacement: .header,
                                       markerType: .bottomLeading(),
                                       xAxisGridStyle: gridStyle,
                                       xAxisLabelPosition: .bottom,
                                       xAxisLabelsFrom: .dataPoint(rotation: .degrees(0)),
                                       xAxisTitle: "Week days",
                                       yAxisGridStyle: gridStyle,
                                       yAxisLabelPosition: .leading,
                                       yAxisNumberOfLabels: 5,
                                       yAxisTitle: "Kcal",
                                       baseline: .zero,
                                       topLine: .maximumValue)
        
        return BarChartData(dataSets: data,
                            metadata: metadata,
                            xAxisLabels: ["One"],
                            barStyle: BarStyle(barWidth: 0.7,
                                               cornerRadius: CornerRadius(top: 5, bottom: 0),
                                               colourFrom: .dataPoints,
                                               colour: ColourStyle(colour: .blue)),
                            chartStyle: chartStyle)
    }
}
