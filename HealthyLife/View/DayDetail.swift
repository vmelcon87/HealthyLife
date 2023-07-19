//
//  DayDetail.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 15/6/22.
//

import SwiftUI

struct DayDetail: View {
    
    // Back button event
    @Environment(\.dismiss) var dismiss
    // Init detail day viewmodel
    @StateObject var dayDetailViewModel: DayDetailViewModel = .init()
    // Navigation link to detail day
    @State private var navToAuxPickerList = false
    // Get selected date
    var selectedDate: Date
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            NavigationLink("", isActive: $navToAuxPickerList) {
                AuxPickerListView(dayDetailViewModel: dayDetailViewModel)
            }
            .opacity(0)
            .frame(maxHeight: 0)
            
            Form {
                // Breakfast section
                Section("Breakfast") {
                    ForEach(dayDetailViewModel.breakfastList, id:\.self) { item in
                        HStack {
                            Text(item.recipeName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.kcal) Kcal")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .breakfast
                                dayDetailViewModel.removeSelectedRecipeItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .breakfast
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Morning section
                Section("Morning Snack") {
                    ForEach(dayDetailViewModel.morningSnackList, id:\.self) { item in
                        HStack {
                            Text(item.recipeName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.kcal) Kcal")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .morningSnack
                                dayDetailViewModel.removeSelectedRecipeItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .morningSnack
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Lunch section
                Section("Lunch") {
                    ForEach(dayDetailViewModel.lunchList, id:\.self) { item in
                        HStack {
                            Text(item.recipeName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.kcal) Kcal")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .lunch
                                dayDetailViewModel.removeSelectedRecipeItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .lunch
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Afternoon section
                Section("Afternoon Snack") {
                    ForEach(dayDetailViewModel.afternoonSnackList, id:\.self) { item in
                        HStack {
                            Text(item.recipeName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.kcal) Kcal")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .afternoonSnack
                                dayDetailViewModel.removeSelectedRecipeItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .afternoonSnack
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Dinner section
                Section("Dinner") {
                    ForEach(dayDetailViewModel.dinner, id:\.self) { item in
                        HStack {
                            Text(item.recipeName)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.kcal) Kcal")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .dinner
                                dayDetailViewModel.removeSelectedRecipeItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .dinner
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Dinner section
                Section("Cardio") {
                    ForEach(dayDetailViewModel.cardioList, id:\.self) { item in
                        HStack {
                            Text(item.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.time) Min")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .cardio
                                dayDetailViewModel.removeSelectedFitnessItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .cardio
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                // Dinner section
                Section("Musculation") {
                    ForEach(dayDetailViewModel.musculationList, id:\.self) { item in
                        HStack {
                            Text(item.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("\(item.weight) Kg")
                        }
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                dayDetailViewModel.selectedItemType = .musculation
                                dayDetailViewModel.removeSelectedFitnessItem(selectedItem: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    
                    // Add button
                    Button {
                        // Open list to select one meal
                        dayDetailViewModel.selectedItemType = .musculation
                        navToAuxPickerList.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(Color("LightBlue"))
                            Text("Add meal")
                                .foregroundColor(Color("LightBlue"))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .accentColor(.white)
        .navigationTitle("Detail Day")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back button item
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                        Text("Dashboard")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            //dayDetailViewModel.fetchTestData()
            dayDetailViewModel.setActualDate(selectedDate: selectedDate)
            dayDetailViewModel.fetchDayData()
        }
        
    }
}

struct DayDetail_Previews: PreviewProvider {
    // Init detail day viewmodel
    @StateObject static var dayDetailViewModel: DayDetailViewModel = .init()
    static var previews: some View {
        DayDetail(selectedDate: Date())
            .onAppear {
                dayDetailViewModel.fetchTestData()
            }
    }
}
