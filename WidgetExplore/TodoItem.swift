//
//  TodoItem.swift
//  WidgetExplore
//
//  Created by Evans Domina Attafuah on 11/11/2023.
//

import Foundation

struct TodoItem: Codable, Identifiable {
    var id = UUID()
    var title: String
}
