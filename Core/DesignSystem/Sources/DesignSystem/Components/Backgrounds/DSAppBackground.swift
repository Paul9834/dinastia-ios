//
//  DSAppBackground.swift
//  DesignSystem
//
//  Created by Paul Montealegre on 03/01/2026.
//

import SwiftUI

public struct DSAppBackground: View {
    let accent: Color

    public init(accent: Color = DSBrand.green) {
        self.accent = accent
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [accent.opacity(0.06), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )

            ZStack {
                Circle()
                    .fill(accent.opacity(0.10))
                    .frame(width: 560, height: 560)
                    .offset(x: -240, y: -320)

                Circle()
                    .fill(accent.opacity(0.08))
                    .frame(width: 620, height: 620)
                    .offset(x: 260, y: 340)
            }
            .blur(radius: 40)
            .opacity(0.45)
            .compositingGroup()
        }
        .ignoresSafeArea()
    }
}
