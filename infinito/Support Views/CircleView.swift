//
//  CircleView.swift
//  infinito
//
//  Created by Armando Visini on 31/10/2020.
//

import SwiftUI

struct CircleView: View {
    var body: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 60, height: 60, alignment: .center)
            .foregroundColor(.blue)
            .shadow(radius: 10)
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView()
    }
}
