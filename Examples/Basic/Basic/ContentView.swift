//
//  ContentView.swift
//  EstimotePositioningSDK
//
//  Created by Estimote on 2024-12-16.

import SwiftUI

struct ContentView: View {
    @ObservedObject private var positioning = Positioning()
    
    var body: some View {
        VStack {
            if let p = positioning.position {
                Text(String(
                    format: "(%.1f, %.1f) ±%.1fm",
                    p.x, p.y, p.error
                ))
                .font(.title.monospacedDigit())
            } else {
                ProgressView("Locating…")
            }
        }
    }
}


#Preview {
    ContentView()
}
