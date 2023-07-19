//
//  UserProfile.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 23/5/22.
//

import SwiftUI

struct UserProfile: View {
    
    // Load viewmodel
    @StateObject var profileViewModel: ProfileViewModel = .init()

    // Control modal visibility
    @Binding var isProfileVisible: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                // User image
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .clipped()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    //.overlay(Circle().stroke(Color.blue, lineWidth: 2.0))
                    .padding(20)
                // Form with user info
                Form {
                    Section(header: Text("User Information")) {
                        
                        // Gender picker
                        Picker("Gender", selection: $profileViewModel.user.gender) {
                            ForEach(profileViewModel.genderOptions, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        // Birthdate selector
                        DatePicker(selection: $profileViewModel.user.birthday, in: ...Date(), displayedComponents: .date) {
                            Text("Birthdate")
                        }
                        
                        // Height selector
                        HStack(spacing: 10) {
                            Stepper("Height", value: $profileViewModel.user.height, in: 140...200)
                            Text("\(profileViewModel.user.height) cm")
                                .frame(width: 60, height: 20, alignment: .center)
                        }

                        // Weight Selector
                        HStack(spacing: 10) {
                            Stepper("Weight", value: $profileViewModel.user.weight, in: 40...120)
                            Text("\(profileViewModel.user.weight) kg")
                                .frame(width: 60, height: 20, alignment: .center)
                        }
                    }
                }
                .background(.white)
                // Navigation bar
                .navigationTitle("User Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    // Cancel button item
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isProfileVisible = false
                        }) {
                            Text("Back")
                                .foregroundColor(.white)
                        }
                    }
                    // Save button item
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            profileViewModel.saveUser()
                            isProfileVisible = false
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .accentColor(.white)
        .onAppear() {
            // Load data if exists
            profileViewModel.fetchUser()
        }
    }
}
// Problem with previews? see: https://stackoverflow.com/questions/62310925/swiftui-preview-canvas-crashes-with-core-data
struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(isProfileVisible: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
