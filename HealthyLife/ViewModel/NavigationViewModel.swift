//
//  NavigationViewModel.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 20/5/22.
//

import Foundation

class NavigationViewModel: ObservableObject {
    
    @Published var currentPage: Page = .dashboard
    
    init() {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
    }
}

// Set available pages
enum Page {
    case dashboard
    case receipes
    case fitness
    case summary
}
