//
//  DSMainTabRoot.swift
//  DesignSystem
//
//  Created by Paul Montealegre on 03/01/2026.
//

import SwiftUI

public struct DSMainTabRoot<Content: View>: View {
    private let accent: Color
    private let content: Content

    public init(
        accent: Color = DSBrand.green,
        @ViewBuilder content: () -> Content
    ) {
        self.accent = accent
        self.content = content()
    }

    public var body: some View {
        NavigationStack {
            content
        }
        .background(DSAppBackground(accent: accent))
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 92)
        }
    }
}
