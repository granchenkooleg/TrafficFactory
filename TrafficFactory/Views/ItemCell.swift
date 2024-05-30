//
//  ItemCall.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import SwiftUI
import Combine

struct ItemCell: View {
    let item: Item
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        VStack {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.primary.opacity(0.5))
                        .aspectRatio(1, contentMode: .fit)
                    ProgressView(value: imageLoader.downloadProgress, total: 1.0)
                        .progressViewStyle(GaugeProgressStyle())
                        .frame(width: 70, height: 70)
                    Text("Loading...")
                        .foregroundColor(.white.opacity(0.5))
                        .font(.caption2)
                        .padding(8)
                }
            }
            
            Text(item.title)
                .font(.headline)
                .padding(.top, 3)
            Text(item.description)
                .font(.subheadline)
                .padding(.bottom, 8)
        }
        .onAppear {
            imageLoader.loadImage(from: item.imageURL)
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        .shadow(radius: 5)
    }
}

#Preview {
    ItemCell(
        item:
            Item(
                title: "Hi ✌️",
                description: "Hello world",
                imageURL: "https://496.ams3.cdn.digitaloceanspaces.com/img/1.jpg"
            )
    )
}
