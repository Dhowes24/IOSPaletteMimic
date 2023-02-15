//
//  picture-intake-screen.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/21/22.
//

import SwiftUI

struct pictureIntakeScreen: View {
    
    @ObservedObject private var vm = pictureIntake_ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing:0){
                imageSelectSubView(palette: vm.firstPalette, colorifiedPalette: vm.firstColorifiedPalette, sortedArr: vm.firstSortedArr, geometry: geometry)
//                ZStack{
//                    backgroundPalette(height: geometry.size.height, colorPalette: vm.firstColorifiedPalette)
//
//                    selectedPhoto(width: geometry.size.width*0.4, image: $vm.firstImage)
//                        .frame(width: geometry.size.width*0.4)
//
//                    if vm.firstProgress > 0 && vm.firstProgress < 1 {
//                        ZStack{
//                            Circle()
//                                .stroke(
//                                    Color.pink.opacity(0.5),
//                                    lineWidth: 20)
//                            Circle()
//                                .trim(from: 0, to: vm.firstProgress)
//                                .stroke(
//                                    Color.pink,
//                                    style: StrokeStyle(
//                                        lineWidth: 20,
//                                        lineCap: .round)
//                                )
//                                .rotationEffect(.degrees(-90))
//                                .animation(.default, value: vm.firstProgress)
//                        }
//                        .frame(width: geometry.size.width*0.4, height: geometry.size.width*0.4)
//                    }
//                }
                
//                ZStack{
//                    backgroundPalette(height: geometry.size.height, colorPalette: vm.secondColorifiedPalette)
//                    
//                    selectedPhoto(width: geometry.size.width*0.4, image: $vm.secondImage)
//                        .frame(width: geometry.size.width*0.4)
//                }
                
                Spacer()
                
                Button {
                    Task{
                        await vm.UInt32_call()
                    }
                    //                        finalImage = createPhoto(pixels: secondImageArr!, width: Int(viewModel.secondImage!.size.width), height: Int(viewModel.secondImage!.size.height))
                    //
                    //                        showFinal.toggle()
                    
                } label: {
                    Text("Present Screen")
                        .font(.title2)
                        .padding()
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            
            .sheet(isPresented: $vm.showIntro ) {
                intro_modal()
            }
            
//            if vm.showFinal {
//                finalImageModal(showView: $vm.showFinal, photo: vm.finalImage)
//                    .zIndex(1)
//                    .transition(.scale(scale: 0, anchor: .center))
//            }
        }
    }
}

struct pictureIntakeScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        pictureIntakeScreen()
    }
}
