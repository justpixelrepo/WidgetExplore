//
//  BatteryWidget.swift
//  BatteryWidget
//
//  Created by Evans Domina Attafuah on 01/11/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), batteryLevel: UIDevice.current.batteryLevel)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), batteryLevel: UIDevice.current.batteryLevel)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let batteryLevel = UIDevice.current.batteryLevel
        let entry = SimpleEntry(date: currentDate, batteryLevel: batteryLevel)
        let timeline = Timeline(entries: [entry], policy: .after(entryDate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let batteryLevel: Float
}

struct BatteryWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            SmallEntryView(entry: entry)
        default:
            MediumEntryViewTwo(entry: entry)
        } }
}

struct SmallEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(self.batteryPercentage())
            .font(.system(size: 40.0, weight: .light))
            .multilineTextAlignment(.center)
            .foregroundColor(.black)
    }
    
    func batteryPercentage() -> String {
        let percent = abs(Int(entry.batteryLevel * 100))
        return "\(percent)%"
    }
}

struct MediumEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Battery Status")
                .font(.system(size: 20.0, weight: .light))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            Text(self.batteryPercentage())
                .font(.system(size: 40.0, weight: .light))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
        }
    }
    
    func batteryPercentage() -> String {
        let percent = abs(Int(entry.batteryLevel * 100))
        return "\(percent)%"
    }
}

struct MediumEntryViewTwo : View {
    var entry: Provider.Entry
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                ZStack{
                    Circle()
                        .stroke(lineWidth: 20.0)
                        .opacity(0.3)
                        .foregroundColor(.blue)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(abs(entry.batteryLevel)))
                        .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: 270.0))
                }
                .padding(.vertical, 28.0)
                Spacer()
                Text(self.batteryPercentage())
                    .font(.system(size: 40.0, weight: .light))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Spacer()
            }
            .frame(maxHeight: geometry.size.height)
            .padding(.horizontal, 30.0)
        }
    }
    
    func batteryPercentage() -> String {
        let percent = abs(Int(entry.batteryLevel * 100))
        return "\(percent)%"
    }
}


struct BatteryWidget: Widget {
    let kind: String = "BatteryWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BatteryWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BatteryWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Battery Status")
        .description("View the battery status of your iPhone on your Home Screen.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    BatteryWidget()
} timeline: {
    SimpleEntry(date: .now, batteryLevel: 0.71)
    
}

#Preview(as: .systemMedium) {
    BatteryWidget()
} timeline: {
    SimpleEntry(date: .now, batteryLevel: 0.71)
    
}
