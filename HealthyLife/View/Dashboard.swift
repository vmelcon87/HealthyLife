//
//  Dashboard.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 20/5/22.
//

import SwiftUI

struct Dashboard: View {
    // Load viewmodel
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    
    // Control profile visibility
    @State private var isProfileVisible = false
    // Navigation link to detail day
    @State private var navToDetailFromDay = false
    
    // Icons and types for both cards
    let mealIcons = ["sunrise", "sun.min", "sun.max", "sunset", "moon"]
    let mealTypes: [KindDayType] = [KindDayType.breakfast, KindDayType.morningSnack, KindDayType.lunch, KindDayType.afternoonSnack, KindDayType.dinner]
    let finetssIcons = ["bolt.square", "waveform.path.ecg.rectangle"]
    let fitnessTypes: [KindDayType] = [KindDayType.cardio, KindDayType.musculation]
    
    // Seleted date
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink("", isActive: $navToDetailFromDay) {
                    DayDetail(selectedDate: selectedDate)
                }
                .opacity(0)
                .frame(maxHeight: 0)
                
                // Top week selector
                HStack(alignment: .top) {
                    HStack(spacing: 0) {
                        // Back arrow button
                        Button {
                            dashboardViewModel.goToPreviousWeek()
                        } label: {
                            Image(systemName: "arrowtriangle.left.fill")
                                .imageScale(.large)
                                .frame(width: 40, height: 41, alignment: .center)
                                .background(.white)
                                .foregroundColor(.black)
                        }
                        // Separator
                        Divider()
                            .frame(maxWidth: 1, maxHeight: 41).background(.gray)
                        
                        // Current week
                        Text(dashboardViewModel.currentWeekText)
                            .frame(maxWidth: .infinity)
                            .padding(10)
                        
                        // Separator
                        Divider()
                            .frame(maxWidth: 1, maxHeight: 41).background(.gray)
                        
                        // Next arrow button
                        Button {
                            dashboardViewModel.goToNextWeek()
                        } label: {
                            Image(systemName: "arrowtriangle.right.fill")
                                .imageScale(.large)
                                .frame(width: 40, height: 41, alignment: .center)
                                .background(.white)
                                .foregroundColor(.black)
                        }
   
                    }
                    .background(.white)
                    .cornerRadius(4)
                    .padding(10)
                    
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .background(Color("TabViewColor"))
                
                // Cards content
                ScrollView {
                    // Meals card
                    DashboardCard(miniCardIconds: mealIcons, cardText: "MEALS", cardIcon: "cart", navToDetailFromDay: $navToDetailFromDay, selectedDate: $selectedDate, kindDayTypes: mealTypes)
                        .environmentObject(dashboardViewModel)
                    
                    // Fitness card
                    DashboardCard(miniCardIconds: finetssIcons, cardText: "FITNESS", cardIcon: "bolt.circle", navToDetailFromDay: $navToDetailFromDay, selectedDate: $selectedDate, kindDayTypes: fitnessTypes)
                        .environmentObject(dashboardViewModel)
                }
            }
            .background(Color("BG"))
            // Navigation bar
            .navigationTitle("Dashboard")
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
            // Modal screen with profile
            .sheet(isPresented: $isProfileVisible) {
                UserProfile(isProfileVisible: $isProfileVisible)
            }
            .onAppear() {
                dashboardViewModel.getCurrentWeek(currentDate: Date())
                dashboardViewModel.fetchCurrentWeekData()
            }
        }
    }
}

// Dashboard card blueprint
struct DashboardCard: View {
    // Load viewmodel
    @EnvironmentObject var dashboardViewModel: DashboardViewModel
    
    // Set card columns
    let gridItemLayout = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
    // Set mini card icons
    var miniCardIconds: [String]
    // Set title card
    var cardText: String
    // Set card icon
    var cardIcon: String
    // Perform navigation to detail day
    @Binding var navToDetailFromDay: Bool
    // Perform changes on selected date
    @Binding var selectedDate: Date
    // Saves kind day types
    let kindDayTypes: [KindDayType]
    
    var body: some View {
        VStack {
            // Title card and icon
            HStack {
                Text(cardText)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                Image(systemName: cardIcon)
                    .imageScale(.large)
            }
            .padding(.horizontal, 20)
            .padding(.top, 14)
            
            Divider()
                .padding(.horizontal, 10)
            
            // Body card with little cads
            LazyVGrid(columns: gridItemLayout, spacing: 14) {
                ForEach(0..<dashboardViewModel.currentWeekNames.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 0) {
                        // Title little card
                        HStack() {
                            Text(dashboardViewModel.currentWeekNames[i])
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(dashboardViewModel.currentWeekDays[i])
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color("LightBlue"))
                        
                        Divider()
                            .frame(maxHeight: 1).background(.gray)
                        
                        // Meals icons
                        HStack {
                            ForEach(0..<miniCardIconds.count, id: \.self) { index in
                                Image(systemName: miniCardIconds[index])
                                    .foregroundColor(dashboardViewModel.getDayColorData(currentDay: dashboardViewModel.currentDateWeekDays[i], type: kindDayTypes[index]))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 4)
                        .background(Color("BGCard"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                    }
                    // Round little cards
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.gray, lineWidth: 2)
                    )
                    .cornerRadius(4)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        selectedDate = dashboardViewModel.currentDateWeekDays[i]
                        navToDetailFromDay.toggle()
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 14)
            
        }
        .background(.white)
        .cornerRadius(6)
        .padding(10)
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
            .environmentObject(DashboardViewModel())
    }
}
