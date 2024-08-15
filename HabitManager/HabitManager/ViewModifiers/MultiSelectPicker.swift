//
//  File.swift
//  HabitManager
//
//  Created by Mac on 2024-08-14.
//

import SwiftUI

struct MultiSelectPicker: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]

    var body: some View {
        Section(header: Text(title)) {
            ForEach(options, id: \.self) { option in
                MultiSelectRow(option: option, isSelected: selections.contains(option)) {
                    if selections.contains(option) {
                        selections.removeAll { $0 == option }
                    } else {
                        selections.append(option)
                    }
                }
            }
        }
    }
}

struct MultiSelectRow: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(option)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
        .foregroundColor(.primary)
    }
}

