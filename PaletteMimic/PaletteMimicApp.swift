//
//  PaletteMimicApp.swift
//  PaletteMimic
//
//  Created by Derek Howes on 11/21/22.
//

import SwiftUI

@main
struct PaletteMimicApp: App {
    @StateObject var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            mom_view().environmentObject(viewRouter)
        }
    }
}
