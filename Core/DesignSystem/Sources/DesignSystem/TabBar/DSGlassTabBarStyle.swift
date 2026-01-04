//
//  DSAppBackground.swift
//  DesignSystem
//
//  Created by Paul Montealegre on 03/01/2026.
//
import SwiftUI

public struct DSGlassTabBarStyle: ViewModifier {
    private let accent: Color

    public init(accent: Color = DSBrand.green) {
        self.accent = accent
    }

    public func body(content: Content) -> some View {
        content
            .tint(accent)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithTransparentBackground()

                appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
                appearance.backgroundColor = UIColor(accent.opacity(0.06))

                appearance.shadowColor = UIColor.black.withAlphaComponent(0.08)

                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
    }
}

public extension View {
    func dsGlassTabBar(accent: Color = DSBrand.green) -> some View {
        modifier(DSGlassTabBarStyle(accent: accent))
    }
}
