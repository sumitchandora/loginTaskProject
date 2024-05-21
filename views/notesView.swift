//
//  notesView.swift
//  loginTaskProject
//
//  Created by Sumit Chandora on 21/05/24.
//

import SwiftUI

struct DetailedView: View {
    var title: String 
    var des: String
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.9).ignoresSafeArea().rotationEffect(.degrees(210))
            Color.secondary.opacity(0.4).ignoresSafeArea()
            VStack(alignment: .leading, spacing: 40) {
                //                HStack {
//                VStack(alignment: .center) {
                    Text("**Title:**")
                        .font(.title)
                        .underline()
                    Text("\(title)")
                        .font(.title2)
//                }
//                VStack(alignment: .center) {
                    Text("**Description:**")
                        .font(.title)
                        .underline()
                        .font(.title2)
                    Text("\(des)")
                        .font(.title2)
//                }
            }
        }
    }
}


