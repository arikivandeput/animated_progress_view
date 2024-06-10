//
//  AnimatedProgressView.swift
//  AnimatedProgress
//
//  Created by Peter Put on 20/02/2024.
//

import SwiftUI

struct AnimatedProgressView: View {
    @State private var scales: [CGFloat]
    private let data: [AnimationData]
    private var animation = Animation.easeInOut.speed(0.5)
    private var color: Color
    
    //Our initializer with a default number of dots of three and color green
    init(numberOfDots: Int = 3, color: Color = .green) {
        self.color = color
        _scales = State(initialValue: Array(repeating: 0, count: numberOfDots))
        data = Array(repeating: AnimationData(delay: 0.2), count: numberOfDots).enumerated().map { (index, data) in
            var modifiedData = data
            modifiedData.delay *= Double(index)
            return modifiedData
        }
    }
    
    func animateDots() {
        for (index, data) in data.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + data.delay) {
                animateDot(binding: $scales[index], animationData: data)
            }
        }
        // Repeat every second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            animateDots()
        }
    }
    
    func animateDot(binding: Binding<CGFloat>, animationData: AnimationData) {
        withAnimation(animation) {
            binding.wrappedValue = 1
        }
        //runs on main queue in async mode every 0.4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(animation) {
                binding.wrappedValue = 0.2
            }
        }
    }
    //the part which is rendered
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<scales.count, id: \.self) { index in
                    DotView(scale: $scales[index], color: color)
                }
            }
        }
        .onAppear {
            animateDots()
        }
    }
}

struct AnimationData {
    var delay: TimeInterval
}

private struct DotView: View {
    @Binding var scale: CGFloat
    var color: Color

    var body: some View {
        Circle()
            .fill(color.opacity(scale >= 0.7 ? 1 : 0.7))
            .scaleEffect(scale)  
            .frame(width: 50, height: 50, alignment: .center)
    }
}
