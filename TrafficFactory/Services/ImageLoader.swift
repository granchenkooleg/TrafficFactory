//
//  ImageLoader.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: NSObject, ObservableObject, URLSessionDownloadDelegate {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var downloadProgress: Float = 0.0

    private var downloadTask: URLSessionDownloadTask?
    private static let imageCache = NSCache<NSString, UIImage>()

    func loadImage(from url: String) {
        guard let url = URL(string: url) else { return }

        // Checking cache before downloading
        if let cachedImage = ImageLoader.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = cachedImage
            return
        }

        isLoading = true
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
            // Saving image to cache
            ImageLoader.imageCache.setObject(image, forKey: downloadTask.originalRequest!.url!.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = image
                self.isLoading = false
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            self.downloadProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        }
    }
}

