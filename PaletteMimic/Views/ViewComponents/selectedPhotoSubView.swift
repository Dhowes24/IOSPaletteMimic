//
//  SelectedPhoto.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/22/22.
//

import Foundation
import SwiftUI

struct selectedPhoto: View {
    let geometry: GeometryProxy
    @Binding var image: UIImage?
    @State private var isImagePickerDisplay = false
    @State private var animationAmount = 1.0
        
    @GestureState var press = false
    
    var body: some View {
        HStack{
            VStack{
                Button{
                    withAnimation{
                        animationAmount += 1
                        isImagePickerDisplay.toggle()
                    }
                } label: {
                    
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    else {
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.4)
                    }
                }
                .buttonStyle(.automatic)
                .tint(.black)
            }
            
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$image, sourceType: .photoLibrary)
            }
        }
//        .frame(alignment: .center)
    }
    
}

struct SelectedPhoto_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in

            selectedPhoto(geometry: geometry, image: .constant(nil))

        }
    }
}
