//
//  MainTabView.swift
//  dinastia
//
//  Created by Paul Montealegre on 03/01/2026.
//
import SwiftUI
import DesignSystem

public struct MainTabView: View {
    private let onLogout: () -> Void

    public init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }

    public var body: some View {
        TabView {
            NavigationStack {
                MockHomeView()
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }

            NavigationStack {
                MockPetsView()
            }
            .tabItem { Label("Mascotas", systemImage: "pawprint.fill") }

            NavigationStack {
                MockAppointmentsView()
            }
            .tabItem { Label("Citas", systemImage: "calendar") }

            NavigationStack {
                MockProfileView(onLogout: onLogout)
            }
            .tabItem { Label("Perfil", systemImage: "person.crop.circle") }
        }
        .tint(DSBrand.green)
        .dsGlassTabBar(accent: DSBrand.green)
        .background(DSAppBackground(accent: DSBrand.green))
    }
}

private struct MockHomeView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Home")
            Text("Aquí va FeatureHome después.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Inicio")
    }
}

private struct MockPetsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Mascotas")
            Text("Aquí va FeaturePets después.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Mascotas")
    }
}

private struct MockAppointmentsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Citas")
            Text("Aquí va FeatureAppointments después.")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Citas")
    }
}

private struct MockProfileView: View {
    let onLogout: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Perfil")
            DSPrimaryButton("Cerrar sesión", background: .red) {
                onLogout()
            }
        }
        .padding()
        .navigationTitle("Perfil")
    }
}
