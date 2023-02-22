//
//  progressTrackerSubView.swift
//  PaletteMimic
//
//  Created by Derek Howes on 2/15/23.
//

import SwiftUI

struct progressTrackerSubView: View {
    var geometry: GeometryProxy
    var progress: Double
    
    var body: some View {
        if progress >= 0 && progress <= 1.0 {
            ZStack{
                Circle()
                    .stroke(
                        Color.blue.opacity(0.5),
                        lineWidth: 20)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(
                            lineWidth: 20,
                            lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.default, value: progress)
            }
            .frame(width: geometry.size.width*0.4, height: geometry.size.width*0.4)
        }
    }
}

struct progressTrackerSubView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            
            progressTrackerSubView(geometry: geometry, progress: 0.5)
        }
    }
}
