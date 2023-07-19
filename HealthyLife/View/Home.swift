//
//  ContentView.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 19/5/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var navViewModel: NavigationViewModel
    // Init dashboardViewModel
    @StateObject var dashboardViewModel: DashboardViewModel = .init()
    // Init fitness viewmodel
    //@StateObject var fitnesViewModel: FitnessViewModel = .init()

    var body: some View {
        GeometryReader { geom in
            VStack(spacing: 0) {

                // Page selection
                switch navViewModel.currentPage {
                case .dashboard:
                    Dashboard()
                        .environmentObject(dashboardViewModel)
                case .receipes:
                    Recipes()
                case .fitness:
                    FitnessView()
                case .summary:
                    Summary()
                }
                
                // Tab bar
                HStack {
                    TabBarItem(selectedPage: .dashboard, width: geom.size.width / 4.5, height: geom.size.height / 26, systemIconName: "heart.text.square", tabName: "Dashboard")
                        .environmentObject(navViewModel)
                    
                    TabBarItem(selectedPage: .receipes, width: geom.size.width / 4.5, height: geom.size.height / 26, systemIconName: "list.bullet.rectangle.portrait", tabName: "Recipes")
                        .environmentObject(navViewModel)
                    
                    TabBarItem(selectedPage: .fitness, width: geom.size.width / 4.5, height: geom.size.height / 26, systemIconName: "figure.walk.circle", tabName: "Fitness")
                        .environmentObject(navViewModel)
                    
                    TabBarItem(selectedPage: .summary, width: geom.size.width / 4.5, height: geom.size.height / 26, systemIconName: "chart.pie", tabName: "Summary")
                        .environmentObject(navViewModel)
                }
                .frame(width: geom.size.width, height: geom.size.height / 9)
                .background(Color("TabViewColor"))
                .shadow(radius: 2)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// Tab bar item
struct TabBarItem: View {
    @EnvironmentObject var navViewModel: NavigationViewModel
    
    // Store selected page
    let selectedPage: Page
    
    // Some custom properties
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            // Icon
            Image(systemName: systemIconName)
                .font(.system(size: 30))
                .frame(width: width, height: height)
            // Icon name
            Text(tabName)
                .font(.footnote)
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.top, 10)
        // Tapping method
        .onTapGesture {
            navViewModel.currentPage = selectedPage
        }
        // TODO: Add custom foreground color depending on tapped page
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(NavigationViewModel())
    }
}
