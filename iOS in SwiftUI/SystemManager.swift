//
//  SystemManager.swift
//  iOS in SwiftUI
//
//  Created by Jia Chen Yee on 13/5/23.
//

import Foundation
import SwiftUI

class SystemManager: ObservableObject {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @Published var homeIndicatorState = HomeIndicatorState.resistent(.white)
    @Published var homeIndicatorOffset = 0.0
    
}

extension SystemManager {
    static let shared = SystemManager()
}
