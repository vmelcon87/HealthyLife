//
//  SearchBarView.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 26/5/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchTxt: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Search ...", text: $searchTxt)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            // Add glass icon and clean search action
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        // If edit in course, show clean button
                        if isEditing {
                            Button(action: {
                                self.searchTxt = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 12)
            // Tapping will add clean icon declared on overlay
                .onTapGesture {
                    self.isEditing = true
                }
            // Add cancel text
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.searchTxt = ""
                    
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchTxt: .constant(""))
    }
}
