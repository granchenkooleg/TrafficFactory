//
//  ImageLoaderTests.swift
//  TrafficFactoryTests
//
//  Created by Oleg Granchenko on 30.05.2024.
//

import XCTest
import Combine
import SwiftUI
@testable import TrafficFactory

class ImageLoaderTests: XCTestCase {
    var imageLoader: ImageLoader!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        imageLoader = ImageLoader()
        cancellables = []
    }

    override func tearDown() {
        imageLoader = nil
        cancellables = nil
        super.tearDown()
    }

    func testLoadImageSuccess() {
        let url = "https://496.ams3.cdn.digitaloceanspaces.com/img/1.jpg"
        let expectation = XCTestExpectation(description: "Load image successfully")

        imageLoader.$image
            .dropFirst()
            .sink { image in
                XCTAssertNotNil(image, "Image should not be nil")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        imageLoader.loadImage(from: url)

        wait(for: [expectation], timeout: 10.0)
    }

    func testImageCaching() {
        let url = "https://496.ams3.cdn.digitaloceanspaces.com/img/1.jpg"
        let expectation = XCTestExpectation(description: "Cache image successfully")

        imageLoader.loadImage(from: url)

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(ImageLoader.imageCache.object(forKey: url as NSString), "Image should be cached")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}

