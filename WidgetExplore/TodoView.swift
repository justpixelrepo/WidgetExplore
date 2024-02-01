//
//  TodoView.swift
//  WidgetExplore
//
//  Created by Evans Domina Attafuah on 11/11/2023.
//

import SwiftUI

struct TodoView : View {
    var todos: [TodoItem]
    var onDeleteAction: ((IndexSet) -> Void)?
    var randomSFSymbols: Image {
        let image: [Image] = [
            .init(systemName: "square.grid.3x1.folder.fill.badge.plus"),
            .init(systemName: "externaldrive.badge.icloud"),
            .init(systemName: "checkmark.circle.fill"),
            .init(systemName: "heart.fill"),
            .init(systemName: "person.fill"),
            .init(systemName: "paperplane.fill")
        ]
        return image.randomElement() ?? .init(systemName: "person.fill")
    }
    var randomCheckedSFSymbols: [Image] {
        [.init(systemName: "checkmark.circle.fill"), .init(systemName: "checkmark.circle")]
    }
    var randomBackgroundColor: Color {
        let color: [Color] = [.pink, .purple, .blue, .green, .orange, .yellow]
        return color.randomElement() ?? .pink
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(todos) { item in
                HStack {
                    HStack {
                        randomSFSymbols
                        Text(item.title)
                            .font(.caption)
                        randomCheckedSFSymbols.randomElement() ?? Image(systemName: "checkmark.circle")
                        
                    }
                    .padding(.vertical, 9)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 40).fill(randomBackgroundColor.opacity(0.3)))
                    Spacer()
                }
                
            }
            .onDelete(perform: onDeleteAction ?? { _ in })
            
        }
    }
}
