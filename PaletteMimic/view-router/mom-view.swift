//
//  mom-view.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/21/22.
//

import SwiftUI

struct mom_view: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var openingApp = true
    
    var body: some View {
        ZStack{
            switch viewRouter.currentPage {
            case .main:
                pictureIntakeView()
            }
        }
    }
}

struct mom_view_Previews: PreviewProvider {
    static var previews: some View {
        mom_view()
    }
}
