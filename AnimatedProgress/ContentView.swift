//
//  ContentView.swift
//  AnimatedProgress
//
//  Created by Peter Put on 20/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AnimatedProgressView(numberOfDots: 3,color:.blue)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
