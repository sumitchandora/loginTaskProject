//
//  ContentView.swift
//  loginTaskProject
//
//  Created by Sumit Chandora on 20/05/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.emailOrNum, ascending: true)],
        animation: .default)
    private var items: FetchedResults<UserInfo>
    @State var identity = ""
    @State var password = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color.mint
                .rotationEffect(.degrees(112))
                GeometryReader { proxy in
                    ZStack {
                        LoginPage()
                    }.offset(y: proxy.size.height/3)
                }
            }
            .navigationTitle("Login")
        }
    }
}

#Preview {
    ContentView()
}
