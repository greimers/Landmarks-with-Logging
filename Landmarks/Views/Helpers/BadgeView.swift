//
//  BadgeView.swift
//  Landmarks
//
//  Created by Gabriel Reimers on 07.05.22.
//  Copyright © 2022 Apple. All rights reserved.
//

import SwiftUI

struct BadgeView: View {
    
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            ZStack(alignment: .center) {
                
                ForEach(1...6, id: \.self) { i in
                    
                    Rectangle()
                        .rotation(.degrees(Double(i) * 15))
                        .fill(color)
                        .frame(width: sqrt((size*size/2)), height: sqrt((size*size/2)), alignment: .center)
                    
                
                }

            }
            .frame(width: size, height: size, alignment: .center)
            
        }
        
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView(color: .purple)
    }
}
