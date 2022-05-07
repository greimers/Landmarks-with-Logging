/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The content for the macOS app.
*/

import SwiftUI
import os

struct ContentView: View {
    private var log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LandmarkList")

    
    var body: some View {
        LandmarkList()
            .frame(minWidth: 700, minHeight: 300)
            .onAppear {
                log.notice("LandmarkList appeared")
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
