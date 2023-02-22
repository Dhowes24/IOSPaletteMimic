//
//  final-image-modal.swift
//  PaletteMimic
//
//  Created by Derek Howes on 12/23/22.
//

import SwiftUI

struct finalImageModal: View {
    
    @Binding var showView: Bool
    var photo: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.gray)
                    .frame(width: geometry.size.width-40, height: geometry.size.height-60, alignment: .center)
                
                VStack {
                    Button {
                        withAnimation { self.showView = false }
                    } label:                    {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .buttonStyle(.automatic)
                            .tint(.black)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                }
                
                finalPhoto(width: geometry.size.width*0.4, image: photo)
                    .frame(width: geometry.size.width*0.4)
            }
        }
    }
}

struct finalImageModal_Previews: PreviewProvider {
    static var previews: some View {
        finalImageModal(showView: .constant(false))
    }
}
