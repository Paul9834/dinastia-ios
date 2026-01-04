//
//  DSPrimaryButton.swift
//  DesignSystem
//
//  Created by Paul Montealegre on 03/01/2026.
//

import SwiftUI

public struct DSPrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let background: Color
    let action: () -> Void

    public init(
        _ title: String,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        background: Color = DSBrand.green,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.background = background
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView().tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(background)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.button, style: .continuous))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled || isLoading)
    }
}
