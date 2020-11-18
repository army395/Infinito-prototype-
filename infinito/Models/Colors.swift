//
//  Colors.swift
//  infinito
//
//  Created by Armando Visini on 17/11/2020.
//

import Foundation
import SwiftUI

extension Color{
    static func rgb(r: Double, g: Double, b: Double) -> Color{
        return Color(red: r / 255, green: g / 255, blue: b / 255)
    }
    
    static let outlineColor = Color.rgb(r: 54, g: 255, b: 203)
    static let progressColor = Color.rgb(r: 45, g: 56, b: 95)
    
}
