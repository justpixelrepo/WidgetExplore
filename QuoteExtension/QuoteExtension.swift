//
//  QuoteExtension.swift
//  QuoteExtension
//
//  Created by Evans Domina Attafuah on 17/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (QuoteWidgetEntry) -> Void) {
        completion(QuoteWidgetEntry(date: Date(), quote: placeholderQuote))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteWidgetEntry>) -> Void) {
        let refreshDate = Calendar.current.date(byAdding: .second, value: 30, to: Date())!
        Task {
            do {
                let quote = try await QuoteService().getRandomQuote()
                let entry = QuoteWidgetEntry(date: Date(), quote: quote)

                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            } catch {
                let entry = QuoteWidgetEntry(date: Date(), quote: placeholderQuote)
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
        }
    }
    
    
    let placeholderQuote = Quote(content: "Here is one quality that one must possess to win, and that is definiteness of purpose", author: "Napoleon Hill")
    
    func placeholder(in context: Context) -> QuoteWidgetEntry {
        QuoteWidgetEntry(date: Date(), quote: placeholderQuote)
    }

//    func snapshot(in context: Context) async -> QuoteWidgetEntry {
//        await withCheckedContinuation { continuation in
//            Task {
//                do {
//                    let quote = try await QuoteService().getRandomQuote()
//                    let entry = QuoteWidgetEntry(date: Date(), quote: quote)
//                    continuation.resume(returning: entry)
//                } catch {
//                    let entry = QuoteWidgetEntry(date: Date(), quote: placeholderQuote)
//                    continuation.resume(returning: entry)
//                }
//            }
//        }
//    }
    
}

struct Quote: Codable {
    let content: String
    let author: String
}

struct QuoteService {
    func getRandomQuote() async throws -> Quote {
        guard let url = URL(string: "https://api.quotable.io/random") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Quote.self, from: data)
    }
}

@MainActor
struct QuoteWidgetEntry: TimelineEntry {
    let date: Date
    let quote: Quote
}

struct QuoteExtensionEntryView : View {
    var entry: QuoteWidgetEntry

    var body: some View {
        VStack {
            Text(entry.quote.content)
                .minimumScaleFactor(0.7)
            
            HStack {
                Spacer()
                Text("-")
                Text(entry.quote.author)
                    .italic()
            }
            .font(.footnote)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct QuoteExtension: Widget {
    let kind: String = "QuoteExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            QuoteExtensionEntryView(entry: entry)
                .containerBackground(.orange.gradient.opacity(0.5), for: .widget)
        }
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    QuoteExtension()
} timeline: {
    QuoteWidgetEntry(date: .init(), quote: .init(content: "Here is one quality that one must possess to win, and that is definiteness of purpose", author: "Napoleon Hill"))
}
