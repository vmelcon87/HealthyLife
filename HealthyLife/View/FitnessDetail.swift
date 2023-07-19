//
//  AddFitnessView.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 11/6/22.
//

import SwiftUI

struct FitnessDetail: View {
    // Back button event
    @Environment(\.dismiss) var dismiss
    // Load recipes view model
    @ObservedObject var fitnessViewModel: FitnessViewModel
    // Fitness types
    let fitnessType: [FitnessType] = [.cardio, .musculation]
    
    var body: some View {
        Form {
            Section(header: Text("BASIC DATA")) {
                // Fitness Name
                HStack {
                    Text("Name")
                        .foregroundColor(.gray)
                    if !fitnessViewModel.isEditionMode {
                        Text(fitnessViewModel.selectedFitness.name)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    else {
                        TextField("", text: $fitnessViewModel.selectedFitness.name)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                // Fitness type
                HStack {
                    Text("Fitness Type")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Allow change fitness type while editing
                    if fitnessViewModel.isEditionMode {
                        Picker("", selection: $fitnessViewModel.selectedFitness.type) {
                            ForEach(fitnessType, id: \.self) {
                                Text("\($0 == .cardio ? "CARDIO" : "MUSCULATION")")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    else {
                        Text("\(fitnessViewModel.selectedFitness.type == .cardio ? "CARDIO" : "MUSCULATION")")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            // Extra data section for selected fitness type
            Section(header: Text("EXTRA DATA")) {
                // Section options for cardio
                if fitnessViewModel.selectedFitness.type == .cardio {
                    HStack {
                        Text("Time")
                            .foregroundColor(.gray)
                        if !fitnessViewModel.isEditionMode {
                            Text("\(fitnessViewModel.selectedFitness.time) Min")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        else {
                            HStack(spacing: 4) {
                                // Binding for int binding in textfield
                                TextField("", text: Binding(
                                    get: { String(fitnessViewModel.selectedFitness.time) },
                                    set: { fitnessViewModel.selectedFitness.time = Int16($0) ?? 0 }
                                ))
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity)
                                
                                Text("Min")
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                // Section options for musculation
                else if fitnessViewModel.selectedFitness.type == .musculation {
                    // Repetitions
                    HStack {
                        Text("Repetitions")
                            .foregroundColor(.gray)
                        
                        if !fitnessViewModel.isEditionMode {
                            Text("\(fitnessViewModel.selectedFitness.reps)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        else {
                            // Binding for int binding in textfield
                            TextField("", text: Binding(
                                get: { String(fitnessViewModel.selectedFitness.reps) },
                                set: { fitnessViewModel.selectedFitness.reps = Int16($0) ?? 0 }
                            ))
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Weight
                    HStack {
                        Text("Weight")
                            .foregroundColor(.gray)
                        
                        // Show or edit info depending on edit mode
                        if !fitnessViewModel.isEditionMode {
                            Text("\(fitnessViewModel.selectedFitness.weight) Kg")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        else {
                            HStack(spacing: 4) {
                                // Binding for int binding in textfield
                                TextField("", text: Binding(
                                    get: { String(fitnessViewModel.selectedFitness.weight) },
                                    set: { fitnessViewModel.selectedFitness.weight = Int16($0) ?? 0 }
                                ))
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity)
                                
                                Text("Kg")
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .accentColor(.white)
        // Add recipe edit button
        .overlay(alignment: .bottomTrailing) {
            if !fitnessViewModel.isEditionMode {
                Button {
                    fitnessViewModel.isEditionMode.toggle()
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
        .navigationTitle("Add Fitness")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // Back/Cancel button item
            ToolbarItem(placement: .navigationBarLeading) {
                if !fitnessViewModel.isEditionMode {
                    Button(action: {
                        dismiss()
                        fitnessViewModel.resetData()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                            Text("Fitness")
                                .foregroundColor(.white)
                        }
                    }
                }
                else {
                    // Cancel edition
                    Button(action: {
                        if !fitnessViewModel.isNewFitness {
                            fitnessViewModel.isEditionMode.toggle()
                        }
                        else {
                            dismiss()
                            fitnessViewModel.resetData()
                        }
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                    }
                }
            }
            // Save edit button
            ToolbarItem(placement: .navigationBarTrailing) {
                if fitnessViewModel.isEditionMode {
                    // Save edition
                    Button(action: {
                        fitnessViewModel.isEditionMode.toggle()
                        dismiss()
                        // Save new data here
                        //fitnessViewModel.saveFitness()
                        fitnessViewModel.saveFitnessDDBB()
                        fitnessViewModel.resetData()
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                    }
                }
            }
    }
    }
}

struct AddFitnessView_Previews: PreviewProvider {
    static var fitnessViewModel: FitnessViewModel = .init()
    //static var selectedFitness: FitnessTest = .init(id: UUID(), name: "Cinta", modifDate: Date(), type: .cardio, reps: 0, weight: 0, time: 30)
    static var selectedFitness: FitnessUI = .init(id: UUID(), name: "Press de banca", modifDate: Date(), type: .musculation, reps: 10, weight: 25, time: 0)
    static var previews: some View {
        FitnessDetail(fitnessViewModel: fitnessViewModel)
            .onAppear() {
                fitnessViewModel.initData(fitness: selectedFitness)
            }
    }
}
