//
//  backgroundPalette.swift
//  PaletteMimic
//
//  Created by Derek Howes on 2/1/23.
//

import SwiftUI

struct backgroundPalette: View {
    
    let height: CGFloat
    let colorPalette: [Color]
    
    var body: some View {
        if !colorPalette.isEmpty {
            HStack(spacing: 0){
                ForEach(0..<colorPalette.count) { i in
                    Rectangle()
                        .fill(
                            colorPalette[i]
                        )
                        .frame(width: 26, height: height * 0.4)
                        .ignoresSafeArea()
                        .padding(0)
                }
            }
        }
    }
}

struct backgroundPalette_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            backgroundPalette(height: geometry.size.height ,colorPalette: [])
        }
    }
}
