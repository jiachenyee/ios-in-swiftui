//
//  HomeIndicator.swift
//  iOS in SwiftUI
//
//  Created by Jia Chen Yee on 13/5/23.
//

import SwiftUI

struct HomeIndicator: View {
    
    @ObservedObject var systemManager = SystemManager.shared
    
    var body: some View {
        switch systemManager.homeIndicatorState {
        case .hidden:
            EmptyView()
        case .shown(let color):
            RoundedRectangle(cornerRadius: .infinity)
                .fill(color)
                .frame(width: 140, height: 5)
                .padding(8)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
                .offset(y: systemManager.homeIndicatorOffset)
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { value in
                            systemManager.homeIndicatorOffset = value.translation.height
                        }
                        .onEnded({ value in
                            withAnimation {
                                systemManager.homeIndicatorOffset = 0
                            }
                        })
                )
        case .resistent(let color):
            RoundedRectangle(cornerRadius: .infinity)
                .fill(color)
                .frame(width: 140, height: 5)
                .padding(8)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.all)
                .offset(y: systemManager.homeIndicatorOffset)
                .highPriorityGesture(
                    DragGesture()
                        .onChanged { value in
                            systemManager.homeIndicatorOffset = value.translation.height / 2
                        }
                        .onEnded({ value in
                            systemManager.homeIndicatorOffset = 0
                        })
                )
        }
    }
}

struct HomeIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            HomeIndicator()
        }
    }
}
