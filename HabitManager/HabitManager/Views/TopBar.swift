//
//  TopB ar.swift
//  HabitManager
//
//  Created by Mac on 2024-06-23.
//

import SwiftUI

struct TopBar: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Habit")
                .font(.headline)
                .fontWeight(.bold)
            Image("schedule")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text("Manager")
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.3))
    }
}

#Preview {
    TopBar()
}
