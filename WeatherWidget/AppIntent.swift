//
//  AppIntent.swift
//  WeatherWidget
//
//  Created by Evans Domina Attafuah on 02/12/2023.
//

import WidgetKit
import SwiftUI
import AppIntents
import OpenWeatherMap


struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Change Theme", query: ThemeQuery())
    var theme: Theme?
}

struct Theme: AppEntity {
    var id: UUID = .init()
    var name: String
    var color: Color

    static var defaultQuery = ThemeQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Theme"
    var displayRepresentation: DisplayRepresentation {
        return .init(title: "\(name)")
    }
}

struct ThemeQuery: EntityQuery {
    func entities(for identifiers: [Theme.ID]) async throws -> [Theme] {
        /// Filtering Using ID
        return themes.filter { theme in
            identifiers.contains(where: { $0 == theme.id })
        }
    }
    
    func suggestedEntities() async throws -> [Theme] {
        return themes
    }
    
    func defaultResult() async -> Theme? {
        themes.first
    }
}

var themes: [Theme] = [
    .init(name: "Red", color: .red),
    .init(name: "Blue", color: .blue),
    .init(name: "Green", color: .green),
    .init(name: "Purple", color: .purple)
]
