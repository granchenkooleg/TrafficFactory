//
//  ViewModelTests.swift
//  TrafficFactoryTests
//
//  Created by Oleg Granchenko on 30.05.2024.
//

import XCTest
import Combine
@testable import TrafficFactory

class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = ViewModel(resource: "items")
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadDataSuccess() {
        let expectation = XCTestExpectation(description: "Load data successfully")

        viewModel.$items
            .dropFirst()
            .sink { items in
                XCTAssertFalse(items.isEmpty, "Items should not be empty")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadData()

        wait(for: [expectation], timeout: 5.0)
    }

    func testLoadingState() {
        let expectation = XCTestExpectation(description: "Loading state is set correctly")

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if isLoading {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadData()

        wait(for: [expectation], timeout: 1.0)
    }

    func testErrorState() {
        let vm = ViewModel(resource: "Invalid")
        let expectation = XCTestExpectation(description: "An error message has been shown.")

        vm.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                if errorMessage == nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        vm.loadData()

        wait(for: [expectation], timeout: 1.0)
    }
}

