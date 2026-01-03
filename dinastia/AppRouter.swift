//
//  AppRouter.swift
//  dinastia
//
//  Created by Paul Montealegre on 02/01/2026.
//


import SwiftUI
import Combine

@MainActor
final class AppRouter: ObservableObject {
    enum Root: Hashable { case auth, main }
    enum Route: Hashable { case register }

    @Published var root: Root = .auth
    @Published var path = NavigationPath()

    func goToRegister() { path.append(Route.register) }
    func back() { if !path.isEmpty { path.removeLast() } }

    func authed() {
        root = .main
        path = NavigationPath()
    }

    func logout() {
        root = .auth
        path = NavigationPath()
    }
}
