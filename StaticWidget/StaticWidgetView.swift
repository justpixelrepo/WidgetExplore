//
//  StaticWidgetView.swift
//  WidgetInsightsExtension
//
//  Created by Evans Domina Attafuah on 10/10/2023.
//

import SwiftUI
import WidgetKit

struct StaticWidgetView: View {
    var body: some View {
        ContainerRelativeShape()
            .fill(.indigo)
            .padding(10)
            .frame(width: 100, height: 100)
        
        Text("Hello")
            .font(.title3)
        Text("Static Widget")
            .font(.title2.bold())
            .foregroundStyle(.indigo.gradient)
    }
}

#Preview {
    StaticWidgetView()
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    
}
