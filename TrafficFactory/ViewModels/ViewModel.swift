//
//  ViewModel.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import Foundation
import Combine
import SwiftUI

class ViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var cancellable: AnyCancellable?

    init() {
        loadData()
    }

    func loadData() {
        isLoading = true
        errorMessage = nil

        cancellable = DataService.shared.fetch(forResource: "items", withExtension: "json")
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.isLoading = false
                    }
                }
            }, receiveValue: { items in
                DispatchQueue.main.async {
                    //                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // To show the loader
                    self.items = items
                    self.isLoading = false
                }
            })
    }
}
