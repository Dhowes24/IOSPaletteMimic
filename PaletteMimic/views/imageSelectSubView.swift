//
//  imageSelectSubView.swift
//  PaletteMimic
//
//  Created by Derek Howes on 2/10/23.
//

import SwiftUI

struct imageSelectSubView: View {
    
    @ObservedObject var vm = imageSelectSub_ViewModel()
    
    var image: UIImage?
    
    var palette: [UInt32]
    var colorifiedPalette: [Color]
    var sortedArr: [UInt32]
    var progress = 0.0
    let geometry: GeometryProxy
    
    var body: some View {
        VStack{
            ZStack{
                backgroundPalette(height: geometry.size.height, colorPalette: vm.colorifiedPalette)
                
                selectedPhoto(width: geometry.size.width*0.4, image: $vm.image)
                    .frame(width: geometry.size.width*0.4)
                
                if vm.progress > 0 && vm.progress < 1 {
                    ZStack{
                        Circle()
                            .stroke(
                                Color.pink.opacity(0.5),
                                lineWidth: 20)
                        Circle()
                            .trim(from: 0, to: vm.progress)
                            .stroke(
                                Color.pink,
                                style: StrokeStyle(
                                    lineWidth: 20,
                                    lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.default, value: vm.progress)
                    }
                    .frame(width: geometry.size.width*0.4, height: geometry.size.width*0.4)
                }
            }
            Button{
                vm.UInt32_call()
            } label: {
                Text("mimic")
            }
        }
        
    }}
