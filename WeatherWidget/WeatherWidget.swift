//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Evans Domina Attafuah on 02/12/2023.
//

import WidgetKit
import SwiftUI
import OpenWeatherMap

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), forecast: .none)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        await withCheckedContinuation { continuation in
            WeatherManager.shared.fetchCurrent { forecast in
                let entry = SimpleEntry(date: Date(), configuration: configuration, forecast: forecast)
                continuation.resume(returning: entry)
            }
        }
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        return await withCheckedContinuation { continuation in
            WeatherManager.shared.fetchCurrent { forecast in
                let entry = SimpleEntry(date: Date(), configuration: configuration, forecast: forecast)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                continuation.resume(returning: timeline)
            }
        }
    }
    

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let forecast: CityWeather?
}

extension CityWeather {
    static let london = OpenWeatherMap.CityWeather(name: "London", id: 2643743, timezone: .max, coordinate: Coordinate(lat: 51.5085, lon: -0.1257), weatherDescriptions: .none, attributes: .none, wind: .none)
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let textColor: Color = entry.configuration.theme?.color ?? .blue
        if let forecast = entry.forecast {
            ZStack {
               // backgroundColor.ignoresSafeArea()
                HStack(alignment: .center, spacing: 20.0) {
                    VStack(alignment: .center) {
                        Text(forecast.name)
                            .font(.system(size: 24.0, weight: .bold))
                            .foregroundColor(textColor)
                        
                        if let attributes = forecast.attributes {
                            let kelvin = attributes.temperature
                            Text("\(convertToCelsius(kelvin: kelvin))°C")
                                .font(.system(size: 40.0, weight: .light))
                                .foregroundColor(textColor)
                            
                        }
                    }

                    VStack(alignment: .leading) {
                        if let data = forecast.weatherDescriptions?.first {
                            Text(data.shortDescription)
                                .font(.system(size: 15, weight: .regular))
                                
                            Text(data.longDescription)
                                .font(.system(size: 12, weight: .regular))
                                
                            let imageKey = data.iconName.rawValue
                            let imageUrl = self.getImageUrlString(key: imageKey)

                            if let url = URL(string: imageUrl),
                                let imageData = try? Data(contentsOf: url),
                                let uiImage = UIImage(data: imageData) {

                                   Image(uiImage: uiImage)
                                    .frame(width: 50, height: 25.0)
                            }
                        }
                    }
                }
                .padding()
            }

        } else {
            Text("Unable to fetch forecast!")
        }
    }

    private func convertToCelsius(kelvin: Double) -> Int {
        return Int(kelvin - 273.15)
    }

    private func getImageUrlString(key: String) -> String {
        let imageUrl = "https://openweathermap.org/img/wn/\(key)@2x.png"
        return imageUrl
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Weather Widget")
        .description("This widget displays the latest weather forecast for a location of your choice.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    WeatherWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .init(), forecast: .london)
}
