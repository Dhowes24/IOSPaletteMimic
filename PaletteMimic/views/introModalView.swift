//
//  intro-modal.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/21/22.
//

import SwiftUI

struct intro_modal: View {
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center){
                VStack(alignment: .center){
                    Spacer()
                    Text("Welcome to Palette Mimic!")
                    
                    Spacer()
                    
                    Text("Enter an initial photo to extract it's color palette.\n\nEnter a secondary photo to apply that color palette to it!")
                        .multilineTextAlignment(.leading)
                        .frame(width:300)
                        .padding()
                    
                    Spacer()
                    
                }.frame(width: geometry.size.width / 1.3)
            }.frame(width: geometry.size.width)
        }
    }
}

struct introModal_Previews: PreviewProvider {
    static var previews: some View {
        intro_modal()
    }
}
