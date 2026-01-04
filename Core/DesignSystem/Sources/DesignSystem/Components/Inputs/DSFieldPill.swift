//
//  DSFieldPill.swift
//  DesignSystem
//
//  Created by Paul Montealegre on 03/01/2026.
//

import SwiftUI

public struct DSFieldPillStyle: ViewModifier {
    let isFocused: Bool
    let accent: Color

    public func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: DSRadius.field, style: .continuous)

        content
            .frame(maxWidth: .infinity, minHeight: 56, alignment: .leading)
            .background {
                shape
                    .fill(.thinMaterial)
                    .overlay {
                        shape.strokeBorder(
                            isFocused ? accent.opacity(0.35) : Color.white.opacity(0.20),
                            lineWidth: 1
                        )
                    }
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 8)
            }
            .clipShape(shape)
    }
}

public extension View {
    func dsFieldPill(isFocused: Bool, accent: Color = DSBrand.green) -> some View {
        modifier(DSFieldPillStyle(isFocused: isFocused, accent: accent))
    }
}
