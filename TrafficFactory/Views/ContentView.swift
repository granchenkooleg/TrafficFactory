//
//  ContentView.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel(resource: "items")

    var body: some View {
        NavigationView {
            ZStack {
                ProgressView("Loading...")
                    .opacity(viewModel.errorMessage != nil || !viewModel.items.isEmpty ? 0 : 1)
                if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button(action: {
                            viewModel.loadData()
                        }) {
                            Text("Retry")
                        }
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.items) { item in
                                ItemCell(item: item)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Items")
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
