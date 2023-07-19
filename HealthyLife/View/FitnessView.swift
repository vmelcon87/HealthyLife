//
//  Fitness.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 26/5/22.
//

import SwiftUI

struct FitnessView: View {
    
    // Load recipes view model
    @StateObject var fitnessViewModel: FitnessViewModel = .init()
    
    // Matched geometry namespace
    @Namespace var animation
    
    // Control profile visibility
    @State private var isProfileVisible = false
    // Control profile visibility
    @State private var navigateToDetailFromList = false

    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("", isActive: $navigateToDetailFromList) {
                    FitnessDetail(fitnessViewModel: fitnessViewModel)
                }
                .opacity(0)
                .frame(maxHeight: 0)
                
                VStack {
                    // Add search bar
                    SearchBarView(searchTxt: $fitnessViewModel.searchTxt)
                    // Add filter bar
                    CustomFilterBar()
                        .padding(.horizontal, 20)
                    
                    // Empty message if recipes not available
                    if fitnessViewModel.fitnessList.count == 0 {
                        Text("No fitness exercises available.\nPlease add one with + button")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else if fitnessViewModel.fitnessList.count != 0 &&
                                fitnessViewModel.filteredData.count == 0 {
                        Text("No results for current search")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    // Load fitness list
                    else {
                        List() {
                            ForEach(fitnessViewModel.filteredData, id:\.self) { item in
                                NavigationLink {
                                    FitnessDetail(fitnessViewModel: fitnessViewModel)
                                        .onAppear() {
                                            fitnessViewModel.initData(fitness: item)
                                            navigateToDetailFromList.toggle()
                                        }
                                } label: {
                                    Text(item.name)
                                }
                                .padding(.vertical, 10)
                                // Remove swipe action
                                .swipeActions {
                                    Button(role: .destructive) {
                                        //fitnessViewModel.removeSelectedFitness(fitness: item)
                                        fitnessViewModel.removeSelectedFitnessDDBB(fitness: item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                // Add recipe button
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        fitnessViewModel.initData(fitness: nil)
                        fitnessViewModel.isEditionMode.toggle()
                        navigateToDetailFromList.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.white)
                            .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                    }
                    .background(.blue)
                    .cornerRadius(40)
                    .padding()
                }
                // Navigation bar
                .navigationTitle("Fitness")
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
                .sheet(isPresented: $isProfileVisible) {
                    UserProfile(isProfileVisible: $isProfileVisible)
                }
                // Fetch data on appear
                .onAppear() {
                    //fitnessViewModel.fectchTestData()
                    fitnessViewModel.fetchFitness()
            }
            }
        }
    }
    
    // Custom filters view
    @ViewBuilder
    func CustomFilterBar() -> some View {
        // Filter list names
        let fitnessFilters = ["ALL", "MUSCULATION", "CARDIO"]
        
        HStack(spacing: 10) {
            ForEach(fitnessFilters, id:\.self) { tab in
                Text(tab)
                    .font(.footnote)
                    .fontWeight(.bold)
                    .scaleEffect(0.9)
                    .foregroundColor(fitnessViewModel.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                // Only apply capsule background to slected tab
                    .background {
                        if fitnessViewModel.currentTab == tab {
                            Capsule()
                                .fill(Color("TabViewColor"))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        // Start swipe animation
                        withAnimation { fitnessViewModel.currentTab = tab }
                        // Filter results
                        fitnessViewModel.filterResultsByType()
                    }
            }
        }
    }
}

struct Fitness_Previews: PreviewProvider {
    static var previews: some View {
        FitnessView()
            .environmentObject(FitnessViewModel())
    }
}
