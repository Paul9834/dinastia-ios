//
//  DSAuthBackground.swift
//  DesignSystem
//
//  Created by Paul Montealegre on 03/01/2026.
//

import SwiftUI

public struct DSAuthBackground: View {
    let accent: Color

    public init(accent: Color = DSBrand.green) {
        self.accent = accent
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [accent.opacity(0.10), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )

            ZStack {
                Circle()
                    .fill(accent.opacity(0.18))
                    .frame(width: 520, height: 520)
                    .offset(x: -220, y: -260)

                Circle()
                    .fill(accent.opacity(0.14))
                    .frame(width: 560, height: 560)
                    .offset(x: 240, y: 260)

                RoundedRectangle(cornerRadius: DSRadius.blobCard, style: .continuous)
                    .fill(accent.opacity(0.10))
                    .frame(width: 460, height: 260)
                    .rotationEffect(.degrees(-18))
                    .offset(x: 0, y: -60)
            }
            .blur(radius: 37)
            .opacity(0.5)
            .compositingGroup()
        }
        .ignoresSafeArea()
    }
}
