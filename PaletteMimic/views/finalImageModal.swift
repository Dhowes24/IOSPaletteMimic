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
                    .fill(.orange)
                    .frame(width: geometry.size.width-40, height: geometry.size.height-60, alignment: .center)
                
                VStack {
                    Button {
                        withAnimation { showView.toggle() }
                        
                    } label: {
                        Image(systemName: "x.circle")
                            .foregroundColor(.black)
                            .font(.largeTitle)
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
