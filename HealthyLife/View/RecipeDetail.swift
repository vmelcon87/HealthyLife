//
//  RecipeDetail.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 30/5/22.
//

import SwiftUI

struct RecipeDetail: View {
    
    // Back button event
    @Environment(\.dismiss) var dismiss
    // Link recipes view model
    @ObservedObject var recipesViewModel: RecipesViewModel
    // Set card columns
    let gridItemLayout = [GridItem(.flexible(), spacing: 0), GridItem(.flexible(), spacing: 0)]
    // Alert camera selector control
    @State private var showAlertSelector = false
    // Editable alert control for preparation time
    @State private var showEditablePrepTimeAlertDialog = false
    // Editable alert control for kcal
    @State private var showEditableKcalAlertDialog = false
    // Editable alert control for ingredients
    @State private var showEditableIngrAlertDialog = false
    // Editable alert control for Preparion rules
    @State private var showEditablePrepAlertDialog = false
    // Needed to fill picker with same var type
    let ratingValues = [Int16](1...10)

    var body: some View {
        GeometryReader { geom in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // For previews we need to kwnow if there are any selected recipe
                    ZStack(alignment: .bottom) {
                        // Recipe image
                        Button {
                            // Show image picker
                            if recipesViewModel.isEditionMode {
                                showAlertSelector.toggle()
                            }
                        } label: {
                            ZStack {
                                if let safeImage = UIImage(data: recipesViewModel.selectedRecipe.image!) {
                                    Image(uiImage: safeImage)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        .frame(maxWidth: geom.size.width)
                                }
                                else {
                                    Spacer()
                                        .frame(maxWidth: geom.size.width)
                                        .frame(height: 250)
                                        .background(Color("BG"))
                                        .cornerRadius(8)
                                }
                                
                                // Show only in edition mode
                                if recipesViewModel.isEditionMode {
                                    Image(systemName: "photo.on.rectangle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.blue)
                                        .grayscale(0.8)
                                        .opacity(0.7)
                                }
                            }
                        }
                        
                        // Add remove photo button
                        if recipesViewModel.isEditionMode {
                            // Only show if there is some image
                            if UIImage(data: recipesViewModel.selectedRecipe.image!) != nil {
                                VStack {
                                    Button {
                                        recipesViewModel.selectedRecipe.image = Data()
                                    } label: {
                                        Image(systemName: "trash.square")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.blue)
                                            .grayscale(0.8)
                                            .opacity(0.7)
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .padding()
                            }
                        }

                        // Name and author
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                // Add text fields for user edits
                                if recipesViewModel.isEditionMode {
                                    TextField("Recipe Name", text: $recipesViewModel.selectedRecipe.recipeName)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding(.bottom, -2)
                                    
                                    HStack(spacing: 2) {
                                        Text("Author:")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        
                                        TextField("Author", text: $recipesViewModel.selectedRecipe.author)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                                else {
                                    Text(recipesViewModel.selectedRecipe.recipeName)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    
                                    Text("Author: \(recipesViewModel.selectedRecipe.author)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: geom.size.width / 1.3, maxHeight: 50, alignment: .topLeading)
                            
                            // Name and author edition
                            if recipesViewModel.isEditionMode {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.white)
                                
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .frame(maxWidth: geom.size.width / 1.3, maxHeight: 50, alignment: .topLeading)
                        .background(Color("TabViewColor"))
                        .cornerRadius(8, corners: [.topLeft, .topRight])
                        .shadow(radius: 4)
                        //.alignmentGuide(.bottom) { d in d[.bottom] / 2 }
                    }
                    .padding(.top, 8)
                    
                    // Recipe extra info
                    HStack {
                        HStack(alignment: .center, spacing: 0) {
                            // Rating
                            if recipesViewModel.isEditionMode {
                                ZStack {
                                    Label {
                                        Text("\(recipesViewModel.selectedRecipe.rating)")
                                            .font(.callout)
                                            .foregroundColor(.black)
                                    } icon: {
                                        Image(systemName: "star.fill")
                                            .font(.title3)
                                            .foregroundColor(.yellow)
                                    }
                                    .frame(width: 80, height: 24)
                                    .background(.white)
                                    
                                    Picker(selection: $recipesViewModel.selectedRecipe.rating, label: EmptyView()) {
                                        ForEach(ratingValues, id:\.self) { index in
                                            Text("\(index)").tag(index)
                                        }
                                    }
                                    .labelsHidden()
                                    // Trick to hide label
                                    .accentColor(.black.opacity(0))
                                    .frame(height: 24, alignment: .center)
                                    .pickerStyle(.menu)
                                }
                            }
                            else {
                                Label {
                                    Text("\(recipesViewModel.selectedRecipe.rating)")
                                        .font(.callout)
                                        .foregroundColor(.black)
                                } icon: {
                                    Image(systemName: "star.fill")
                                        .font(.title3)
                                        .foregroundColor(.yellow)
                                }
                                .frame(width: 80, height: 24)
                            }
                            
                            // Prep time
                            Button {
                                // Action to set prep time
                                if recipesViewModel.isEditionMode {
                                    showEditablePrepTimeAlertDialog.toggle()
                                }
                            } label: {
                                Label {
                                    Text("\(recipesViewModel.selectedRecipe.prepTime) m")
                                        .font(.callout)
                                        .foregroundColor(.black)
                                } icon: {
                                    Image(systemName: "clock")
                                        .font(.title3)
                                        .foregroundColor(Color("LightBlue"))
                                }
                            }
                            .frame(width: 90, height: 24)
                            .alert(isPresented: $showEditablePrepTimeAlertDialog,
                                   TextAlert(title: "Preparation Time",
                                             message: "Add preparation time in minutes",
                                             keyboardType: .numberPad) { result in
                                if let text = result {
                                    // Text was accepted
                                    recipesViewModel.selectedRecipe.prepTime = Int16(text) ?? 0
                                } else {
                                    // The dialog was cancelled
                                }
                            })
                            
                            // Kcal
                            Button {
                                // Action to set kcal
                                if recipesViewModel.isEditionMode {
                                    showEditableKcalAlertDialog.toggle()
                                }
                            } label: {
                                Label {
                                    Text("\(recipesViewModel.selectedRecipe.kcal) kcal")
                                        .font(.callout)
                                        .foregroundColor(.black)
                                } icon: {
                                    Image(systemName: "flame.fill")
                                        .font(.title3)
                                        .foregroundColor(.orange)
                                }
                            }
                            .frame(width: 110, height: 24)
                            .alert(isPresented: $showEditableKcalAlertDialog,
                                   TextAlert(title: "Meal Kcal",
                                             message: "Add kcal for selected meal",
                                             keyboardType: .numberPad) { result in
                                if let text = result {
                                    // Text was accepted
                                    recipesViewModel.selectedRecipe.kcal = Int16(text) ?? 0
                                } else {
                                    // The dialog was cancelled
                                }
                            })
                        }
                        .frame(maxWidth: geom.size.width / 1.3, alignment: .center)
                        .padding(.vertical, 8)
                        .background(.white)
                        .cornerRadius(8, corners: [.bottomLeft, .bottomRight])
                        .shadow(radius: 4)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Ingedients header
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Ingredients")
                                .font(.title2)
                                .bold()
                            
                            if recipesViewModel.isEditionMode {
                                // Add ingredient button
                                Button {
                                    // Add ingredient action
                                    if recipesViewModel.isEditionMode {
                                        showEditableIngrAlertDialog.toggle()
                                    }
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundColor(Color("LightBlue"))
                                }
                                .alert(isPresented: $showEditableIngrAlertDialog,
                                       TextAlert(title: "New Ingredient",
                                                 message: "Add an ingredient to recipe.",
                                                 keyboardType: .default) { result in
                                    if let text = result {
                                        // Text was accepted
                                        recipesViewModel.addNewIngredientToRecipe(ingredient: text)
                                    } else {
                                        // The dialog was cancelled
                                    }
                                })
                                .frame(maxWidth: 30)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                        
                        // No ingredients message
                        if recipesViewModel.ingredientList.count == 0 {
                            Text("No ingredients added yet.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                        }
                        // Load ingredient list
                        else {
                            LazyVGrid(columns: gridItemLayout, alignment: .leading, spacing: 14) {
                                ForEach($recipesViewModel.ingredientList) { $ingr in
                                    HStack {
                                        HStack(alignment: .center, spacing: 0) {
                                            Text("· ")
                                                .font(.title2)
                                                .bold()
                                            // Show editable text field for edition mode
                                            if !recipesViewModel.isEditionMode {
                                                Text("\(ingr.content)")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            else {
                                                TextField("Edit ingr", text: $ingr.content, onEditingChanged: { isEdit in
                                                    if isEdit {
                                                        print("Editing")
                                                    }
                                                    else {
                                                        print("Lost edition")
                                                    }
                                                })
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        // Trash button
                                        if recipesViewModel.isEditionMode {
                                            Button {
                                                // Remove ingredient
                                                recipesViewModel.removeIngredientFromRecipe(ingredient: ingr)
                                            } label: {
                                                Image(systemName: "trash")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(.red)
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(10)
                        }
                        
                    }
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.bottom, 20)
                    .padding(.top, 30)
                    .padding(.horizontal, 5)
                    
                    // Preparation header
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("Preparation")
                                .font(.title2)
                                .bold()
                            
                            if recipesViewModel.isEditionMode {
                                // Add ingredient button
                                Button {
                                    // Add ingredient action
                                    if recipesViewModel.isEditionMode {
                                        showEditablePrepAlertDialog.toggle()
                                    }
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .font(.title2)
                                        .foregroundColor(Color("LightBlue"))
                                }
                                .alert(isPresented: $showEditablePrepAlertDialog,
                                       TextAlert(title: "Preparation Rule",
                                                 message: "Add new rule to recipe.",
                                                 keyboardType: .default) { result in
                                    if let text = result {
                                        // Text was accepted
                                        recipesViewModel.addNewRuleToRecipe(rule: text)
                                    } else {
                                        // The dialog was cancelled
                                    }
                                })
                                .frame(maxWidth: 30, maxHeight: 30)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                        
                        // No ingredients message
                        if recipesViewModel.recipeSteps.count == 0 {
                            Text("No preparation steps added yet.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                        }
                        // Load recipe steps list
                        else {
                            ForEach($recipesViewModel.recipeSteps) { $step in
                                HStack {
                                    HStack {
                                        Text("\(step.id).")
                                            .font(.body)
                                            .bold()
                                        // if editing text then use a texteditor
                                        if !recipesViewModel.isEditionMode {
                                            Text("\(step.content)")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        else {
                                            ZStack {
                                                TextEditor(text: $step.content)
                                                    .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                // Trick to keep growing textEditor (dynamic height)
                                                Text(step.content).opacity(0).padding(6)
                                            }
                                        }
                                    }
                                    // Trash button
                                    if recipesViewModel.isEditionMode {
                                        Button {
                                            // Remove recipe rule
                                            recipesViewModel.removeRuleFromRecipe(rule: step)
                                        } label: {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.red)
                                                .padding(.trailing, 10)
                                        }
                                    }
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                    }
                    .background(.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                    .padding(.horizontal, 5)
                    
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 16)
            // Add recipe edit button
            .overlay(alignment: .bottomTrailing) {
                if !recipesViewModel.isEditionMode {
                    Button {
                        recipesViewModel.isEditionMode.toggle()
                    } label: {
                        Image(systemName: "pencil")
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
            }
            // Navigation bar
            .accentColor(.white)
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // Back/Cancel button item
                ToolbarItem(placement: .navigationBarLeading) {
                    if !recipesViewModel.isEditionMode {
                        Button(action: {
                            dismiss()
                            recipesViewModel.resetData()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                Text("Recipes")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    else {
                        // Cancel edition
                        Button(action: {
                            if !recipesViewModel.isNewRecipe {
                                recipesViewModel.isEditionMode.toggle()
                            }
                            else {
                                dismiss()
                                recipesViewModel.resetData()
                            }
                        }) {
                            Text("Cancel")
                                .foregroundColor(.white)
                        }
                    }
                }
                // Save edit button
                ToolbarItem(placement: .navigationBarTrailing) {
                    if recipesViewModel.isEditionMode {
                        // Save edition
                        Button(action: {
                            recipesViewModel.isEditionMode.toggle()
                            dismiss()
                            // Save new data here
                            //recipesViewModel.saveRecipe()
                            recipesViewModel.saveRecipeDDBB()
                            recipesViewModel.resetData()
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                        }
                    }
                }
        }
            // Show camera or image picker
            .fullScreenCover(isPresented: $recipesViewModel.isImagePickerVisible) {
                ImagePicker(sourceType: recipesViewModel.sourceType, completionHandler: recipesViewModel.didSelectImage)
            }
            // Show alert to pick one image source
            .alert(isPresented: $showAlertSelector) {
                Alert(title: Text("Choose source"), message: Text("Please, select one option"), primaryButton: .default(Text("Take Photo")) { recipesViewModel.takePhoto() }, secondaryButton: .default(Text("Gallery")) { recipesViewModel.choosePhoto() })
            }
        }
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static var recipeViewModel: RecipesViewModel = .init()
    static let recipe = RecipeUI(id: UUID(), recipeName: "Tortilla de Patatas", modifDate: Date(), kcal: 417, rating: 8, ingredients: "[{\"id\" : 1, \"content\" : \"3 Eggs\"}, {\"id\" : 2, \"content\" : \"4 potatoes\"}]", preparation: "[{\"id\" : 1, \"content\" : \"Add olive oil to a 10 or 12 inch skillet over medium heat\"}, {\"id\" : 2, \"content\" : \"Add sliced potato and onion to the pan; they should be mostly covered with olive oil\"}]", prepTime: 75, author: "Victor Melcon", image: UIImage(named: "tortillaPatatas")!.jpegData(compressionQuality: 1.0)!)
    
    static var previews: some View {
        RecipeDetail(recipesViewModel: recipeViewModel)
            .onAppear() {
                recipeViewModel.initData(recipe: recipe)
            }
    }
}
