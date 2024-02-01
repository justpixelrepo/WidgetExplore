//
//  ContentView.swift
//  WidgetExplore
//
//  Created by Evans Domina Attafuah on 09/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct NNetworkImageView: View {
    var body: some View {
//        AsyncImage(url: .init(string: "https://picsum.photos/600")) { image in
//            image
//                .resizable()
//              .aspectRatio(contentMode: .fit)
//        } placeholder: {
//            ProgressView()
//        }
        if let data = try? Data(contentsOf: URL(string: "https://picsum.photos/600")!) {
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
}

#Preview {
  //  ContentView()
    NNetworkImageView()
}



