//
//  File.swift
//  DesignSystem
//
//  Created by Nikita Shmatov on 07/06/2026.
//

import SwiftUI

public struct AdaptiveBackgroundView: View {
    let image: UIImage?
    
    public init(image: UIImage?) {
        self.image = image
    }
    
    public var body: some View {
        ZStack {
            Color(hex: "#121212")
                .ignoresSafeArea()
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .saturation(0.5)
                    .blur(radius: 60, opaque: true)
                    .overlay(Color.black.opacity(0.4))
                    .transition(.opacity.animation(.easeInOut(duration: 0.5)))
            }
        }
    }
}
