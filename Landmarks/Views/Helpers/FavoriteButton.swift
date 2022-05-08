/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A button that acts as a favorites indicator.
*/

import SwiftUI
import os

struct FavoriteButton: View {
    @Binding var isSet: Bool
    var log = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "FavoritesButton")

    var body: some View {
        Button {

            isSet.toggle()
            
            log.notice("Fav button tapped")
        } label: {
            Label("Toggle Favorite", systemImage: isSet ? "star.fill" : "star")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .yellow : .gray)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true))
    }
}
