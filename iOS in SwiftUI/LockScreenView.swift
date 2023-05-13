//
//  LockScreenView.swift
//  iOS in SwiftUI
//
//  Created by Jia Chen Yee on 13/5/23.
//

import SwiftUI
import AVFoundation

struct LockScreenView: View {
    
    @ObservedObject var systemManager = SystemManager.shared
    
    @State var date = Date.now
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        return dateFormatter
    }()
    
    let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm"
        
        return dateFormatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            Text(dateFormatter.string(from: date))
                .kerning(0.2)
                .font(.system(size: 21, weight: .semibold))
                .foregroundColor(.white)
                .padding(.top, 38)
            
            Text(timeFormatter.string(from: date))
                .font(.system(size: 108, weight: .semibold, design: .default))
                .kerning(-3)
                .padding(.top, -10)
                .foregroundColor(.white)
            
            Spacer()
            
            HStack {
                LockScreenTorchLightButton()
                Spacer()
                LockScreenButton(imageName: "camera.fill") {
                    print("Open Camera")
                }
            }
            .padding(.horizontal, 46)
            .padding(.bottom, 16)
        }
        .onReceive(systemManager.timer) { _ in
            // target: "Saturday, May 13"
            date = .now
        }
    }
}

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView()
    }
}

struct LockScreenTorchLightButton: View {
    let device = AVCaptureDevice.default(for: AVMediaType.video)
    
    @State private var isTorchOn = {
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        return (device?.torchMode ?? .off) == .on
    }()
    
    var body: some View {
        if device?.hasTorch ?? false {
            LockScreenButton(isOn: isTorchOn, imageName: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill") {
                toggleFlashlight()
            }
        }
    }
    
    func toggleFlashlight() {
        guard let device else { return }
        do {
            try device.lockForConfiguration()
            
            if device.torchMode == .on {
                device.torchMode = .off
            } else {
                device.torchMode = .on
            }
            
            device.unlockForConfiguration()
            
            isTorchOn = device.torchMode == .on
        } catch {
            print("Torch could not be used")
            print(error)
        }
    }
}

struct LockScreenButton: View {
    
    @ObservedObject var systemManager = SystemManager.shared
    
    @State var longPressStartDate: Date?
    @State var scaleDelta = 0.0
    
    var isOn = false
    
    var imageName: String
    
    var action: (() -> Void)
    
    var body: some View {
        Circle()
            .fill(Material.thickMaterial.opacity(isOn ? 1 : 0.5))
            .background(.black.opacity(isOn ? 0 : 0.8))
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .overlay(
                Image(systemName: imageName)
                    .foregroundColor(isOn ? .black : .white)
                    .font(.system(size: 18))
            )
            .scaleEffect(1 + scaleDelta)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if longPressStartDate == nil {
                            longPressStartDate = .now
                        }
                    }
                    .onEnded { _ in
                        if scaleDelta == 1 {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            action()
                        }
                        
                        longPressStartDate = nil
                        
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                            scaleDelta = 0
                        }
                    }
            )
            .onReceive(systemManager.timer) { _ in
                if let longPressStartDate {
                    if scaleDelta != 1 {
                        withAnimation(.linear(duration: 0.1)) {
                            scaleDelta = min(abs(longPressStartDate.timeIntervalSinceNow) / 0.3, 1)
                        }
                        
                        if scaleDelta == 1 {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    }
                }
            }
    }
}
