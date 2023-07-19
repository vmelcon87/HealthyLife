//
//  Summary.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 19/6/22.
//

import SwiftUI
import SwiftUICharts

struct Summary: View {
    // Init viewmodel
    @StateObject var summaryViewModel: SummaryViewModel = .init()
    // Control profile visibility
    @State private var isProfileVisible = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let safeRecipeData = summaryViewModel.eatenData {
                    SummaryCard(titleCard: "Total Eaten Calories: \(summaryViewModel.totalRecipeKcal) Kcal", data: safeRecipeData)
                }
                if let safeFitnessData = summaryViewModel.fitnessData {
                    SummaryCard(titleCard: "Total Fitness Calories: \(summaryViewModel.totalFitnessKcal) Kcal", data: safeFitnessData)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .background(Color("BG"))
            // Navigation bar
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isProfileVisible.toggle()
                    }) {
                        Image(systemName: "person.crop.circle")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                }
            }
            // Show user profile
            .sheet(isPresented: $isProfileVisible) {
                UserProfile(isProfileVisible: $isProfileVisible)
            }
        }
    }
    
    // Summary card blueprint
    struct SummaryCard: View {
        // Set title card
        var titleCard: String
        var data: BarChartData
        
        var body: some View {
            VStack {
                // Title card and icon
                HStack {
                    Text(titleCard)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                
                Divider()
                    .padding(.horizontal, 10)
                
                // Body card
                BarChart(chartData: data)
                    .averageLine(chartData: data,
                                 strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
                    .yAxisGrid(chartData: data)
                    .xAxisLabels(chartData: data)
                    .yAxisLabels(chartData: data, colourIndicator: .custom(colour: ColourStyle(colour: .red), size: 12))
                    .id(data.id)
                    .frame(minWidth: 150, maxWidth: 900, minHeight: 150, idealHeight: 300, maxHeight: 400, alignment: .center)
                    .padding(.top, 10)
                    .padding(.bottom, 14)
                    .padding(.trailing, 10)
                
            }
            .background(.white)
            .cornerRadius(6)
            .padding(10)
        }
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        Summary()
    }
}
