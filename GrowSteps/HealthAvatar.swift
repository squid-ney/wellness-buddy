//
//  HealthAvatar.swift
//  GrowSteps
//
//  Created by Sydney Achinger on 2/22/22.
//

import SwiftUI

struct HealthAvatar: View {
    let healthStatus: Color
    
//    let statusColorPairs = [
//        "low": Color.red,
//        "good": Color.gray,
//        "great": Color.green
//    ]
    
    var body: some View {
        Rectangle()
            .fill(healthStatus)
            .frame(width: 200, height: 200)
    }
}

struct HealthAvatar_Previews: PreviewProvider {
    static var previews: some View {
        HealthAvatar(healthStatus: Color.clear)
    }
}
