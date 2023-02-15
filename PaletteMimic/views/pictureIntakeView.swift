//
//  picture-intake-screen.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/21/22.
//

import SwiftUI

struct pictureIntakeView: View {
    
    @ObservedObject private var vm = pictureIntake_ViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack(spacing:0){
                ZStack{
                    backgroundPalette(geometry: geometry, colorPalette: vm.firstColorifiedPalette)
                    
                    selectedPhoto(geometry: geometry, image: $vm.firstImage)
                        .frame(width: geometry.size.width*0.4)
                    
                    progressTrackerSubView(geometry: geometry, progress: vm.firstProgress)
                }
                
                ZStack{
                    backgroundPalette(geometry: geometry, colorPalette: vm.secondColorifiedPalette)
                    
                    selectedPhoto(geometry: geometry, image: $vm.secondImage)
                        .frame(width: geometry.size.width*0.4)
                    
                    progressTrackerSubView(geometry: geometry, progress: vm.secondProgress)
                }
                
                Spacer()
                
                Button {
                    Task{
                        await vm.UInt32_call()
                    }
                    //                        finalImage = createPhoto(pixels: secondImageArr!, width: Int(viewModel.secondImage!.size.width), height: Int(viewModel.secondImage!.size.height))
                    //
//                    withAnimation{
//                        vm.showFinal.toggle()
//                    }
                    
                } label: {
                    Text("Mimic Palette")
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
            
            if vm.showFinal {
                finalImageModal(showView: $vm.showFinal, photo: vm.finalImage)
                    .zIndex(1)
                    .transition(.scale(scale: 0, anchor: .center))
            }
        }
    }
}

struct pictureIntakeScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        pictureIntakeView()
    }
}
