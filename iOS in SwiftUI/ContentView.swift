//
//  ContentView.swift
//  iOS in SwiftUI
//
//  Created by Jia Chen Yee on 13/5/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var systemManager = SystemManager.shared
    
    var body: some View {
        ZStack {
            LockScreenView()
            HomeIndicator()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
