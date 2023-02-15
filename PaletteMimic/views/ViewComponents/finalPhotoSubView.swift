//
//  SelectedPhoto.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/22/22.
//

import SwiftUI

struct finalPhoto: View {
    let width: CGFloat
    var image: UIImage?
    
    var body: some View {
        HStack{
            VStack{
                
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(width: width, height: width)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
                else {
                    Image(systemName: "snow")
                        .resizable()
                        .frame(width: width, height: width)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
        }
        .frame(alignment: .center)
    }
}

struct finalPhoto_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in

            finalPhoto(width: geometry.size.width*0.4, image: nil)
            
        }
    }
}
