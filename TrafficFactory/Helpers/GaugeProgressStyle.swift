//
//  GaugeProgressStyle.swift
//  TrafficFactory
//
//  Created by Oleg Granchenko on 29.05.2024.
//

import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor = Color.gray
    var strokeWidth = 10.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
