//
//  DataServiceTests.swift
//  TrafficFactoryTests
//
//  Created by Oleg Granchenko on 30.05.2024.
//

import XCTest
import Combine
@testable import TrafficFactory

class DataServiceTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }

    func testFetchItemsSuccess() {
        let dataService = DataService.shared

        let expectation = XCTestExpectation(description: "Fetch items successfully")

        dataService.fetch(forResource: "items", withExtension: "json")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { (items: [Item]) in
                XCTAssertFalse(items.isEmpty, "Items should not be empty")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 5.0)
    }
}

