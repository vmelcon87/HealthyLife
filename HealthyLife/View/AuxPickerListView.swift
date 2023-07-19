//
//  AuxPickerListView.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 15/6/22.
//

import SwiftUI

struct AuxPickerListView: View {
    // Back button event
    @Environment(\.dismiss) var dismiss
    // Prepared viewmodel
    @ObservedObject var dayDetailViewModel: DayDetailViewModel
    
    var body: some View {
        VStack {
            // Add search bar
            SearchBarView(searchTxt: $dayDetailViewModel.searchTxt)
            
            // Content list
            List(dayDetailViewModel.filteredData, id:\.self) { auxItem in
                Button(action: {
                    // Select item and add to corresponding list
                    dayDetailViewModel.addSelectedItemType(selectedItem: auxItem)
                    dismiss()
                }) {
                    Text(auxItem.auxName)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .listStyle(.plain)
        }
        .accentColor(.white)
        .navigationTitle("Pick One")
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
                        Text("Detail Day")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear(){
            //dayDetailViewModel.fetchAuxListData()
            dayDetailViewModel.fetchAuxList()
        }
    }
}

struct AuxPickerListView_Previews: PreviewProvider {
    @StateObject static var dayDetailViewModel: DayDetailViewModel = .init()
    static var previews: some View {
        AuxPickerListView(dayDetailViewModel: dayDetailViewModel)
            .onAppear(){
                //dayDetailViewModel.fetchAuxListData()
                dayDetailViewModel.fetchAuxList()
            }
    }
}
