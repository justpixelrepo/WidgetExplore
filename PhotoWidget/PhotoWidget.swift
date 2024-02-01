//
//  PhotoWidget.swift
//  PhotoWidget
//
//  Created by Evans Domina Attafuah on 17/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PhotoWidgetEntry {
        PhotoWidgetEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (PhotoWidgetEntry) -> ()) {
        let entry = PhotoWidgetEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PhotoWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for i in 1...5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: i, to: currentDate)!
            let entry = PhotoWidgetEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct NetworkImageView: View {
    var body: some View {
        if let data = try? Data(contentsOf: URL(string: "https://picsum.photos/600")!) {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
    }
}

struct PhotoWidgetEntry: TimelineEntry {
    var date = Date()
}

struct PhotoWidgetEntryView : View {
    var entry: PhotoWidgetEntry

    var body: some View {
        NetworkImageView()
            .scaleEffect(.init(width: 1.2, height: 1.2))
           
    }
}

struct PhotoWidget: Widget {
    let kind: String = "PhotoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PhotoWidgetEntryView(entry: entry)
                .containerBackground(.thinMaterial, for: .widget)
            
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge])
    }
        
}

#Preview(as: .systemLarge) {
    PhotoWidget()
} timeline: {
    PhotoWidgetEntry()
}

