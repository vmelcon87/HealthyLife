//
//  Recipes.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 25/5/22.
//

import SwiftUI

struct Recipes: View {
    
    // Load recipes view model
    @StateObject var recipesViewModel: RecipesViewModel = .init()
    
    // Control profile visibility
    @State private var isProfileVisible = false
    // Navigate to detail recipe view
    @State private var navigateToDetailFromList = false
    
    // Add date formatter for last modified date
    static let modifiedDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                // Add search bar
                SearchBarView(searchTxt: $recipesViewModel.searchTxt)
                // Empty message if recipes not available
                if recipesViewModel.recipesList.count == 0 {
                    Text("No recipes available.\nPlease add one with + button")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                // Message for no search results
                else if recipesViewModel.recipesList.count != 0 &&
                            recipesViewModel.filteredData.count == 0 {
                    Text("No results for current search")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                else {
                    // Recipes list, filtering by search text
                    List(recipesViewModel.filteredData, id:\.self) { item in
                        NavigationLink {
                            // Navigate to recipe detail
                            RecipeDetail(recipesViewModel: recipesViewModel)
                                .onAppear() {
                                    recipesViewModel.initData(recipe: item)
                                    navigateToDetailFromList.toggle()
                                }
                        } label: {
                            HStack(spacing: 26) {
                                // Check if recipe has an image
                                if let safeImage = item.image, let safeUIImage = UIImage(data: safeImage) {
                                    Image(uiImage: safeUIImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                }
                                else {
                                    Image(systemName: "photo.on.rectangle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.blue)
                                        .grayscale(0.8)
                                        .opacity(0.7)
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(item.recipeName)
                                        .font(.title2)
                                    
                                    Text("Last Modification: \(item.modifDate, formatter: Self.modifiedDateFormat) · \(item.kcal)KCal")
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .padding(.leading, 6)
                        // Remove swipe action
                        .swipeActions {
                            Button(role: .destructive) {
                                //recipesViewModel.removeSelectedRecipe(recipe: item)
                                recipesViewModel.removeSelectedRecipeDDBB(recipe: item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            // Add recipe button
            .overlay(alignment: .bottomTrailing) {
                Button {
                    // Navigate to create new recipe detail, with no data loaded
                    recipesViewModel.initData(recipe: nil)
                    recipesViewModel.isEditionMode.toggle()
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
                
                NavigationLink("", isActive: $navigateToDetailFromList) {
                    RecipeDetail(recipesViewModel: recipesViewModel)
                }
                .opacity(0)
            }
            // Navigation bar
            .navigationTitle("Recipes")
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
            // Fetch data on appear
            .onAppear() {
                //recipesViewModel.fetchTestData()
                recipesViewModel.fetchRecipes()
            }
        }
    }
}

struct Recipes_Previews: PreviewProvider {
    static var previews: some View {
        Recipes()
            .environmentObject(RecipesViewModel())
    }
}

