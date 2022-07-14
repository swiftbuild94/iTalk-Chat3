//
//  ImageZoom.swift
//  iTalk Chat
//
//  Created by Patricio Benavente on 16/05/2022.
//

import SwiftUI

struct ImageZoom: View {
    var body: some View {
        Image(systemName: "ant.fill")
            .edgesIgnoringSafeArea(.all)
    }
}

struct ImageZoom_Previews: PreviewProvider {
    static var previews: some View {
        ImageZoom()
    }
}
