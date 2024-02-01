//
//  TodoWidgetExtension.swift
//  TodoWidgetExtension
//
//  Created by Evans Domina Attafuah on 11/11/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, items: loadTodos())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: .now, items: loadTodos())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: .now, items: loadTodos())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func loadTodos() -> [TodoItem] {
        guard let defaults = UserDefaults(suiteName: "group.io.justpixel.WidgetExplore") else { return [] }
            guard let data = defaults.value(forKey: "todos") as? Data else { return [] }
            let decoder = PropertyListDecoder()
            guard let list = try? decoder.decode([TodoItem].self, from: data) else { return []}
            return list.suffix(3)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [TodoItem]
}

struct TodoWidgetExtensionEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        VStack {
            TodoView(todos: entry.items)
        }
    }
}

struct TodoWidgetExtension: Widget {
    let kind: String = "TodoWidgetExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TodoWidgetExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodoWidgetExtensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Todo Widget")
        .description("A simple widget that displays your todo list on the home screen.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    TodoWidgetExtension()
} timeline: {
    SimpleEntry(date: .now, items: [.init(title: "pickup care"), .init(title: "go to the gym"), .init(title: "buy groceries")])
}
