//
//  ContentView.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationStack {
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
                    List(viewModel.items) { item in
                        ItemCell(item: item)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Items")
        }
    }
}

#Preview {
    ContentView()
}
