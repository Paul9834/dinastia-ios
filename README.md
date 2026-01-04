# Dinastía iOS

Aplicación iOS de **Dinastía** (medicina y cuidado de animales) construida con **SwiftUI**, **arquitectura modular**, **MVVM** y **Dependency Injection** centralizada.

El objetivo del proyecto es escalar de forma ordenada: múltiples features, dependencias controladas, separación clara de responsabilidades y flujos explícitos (Auth → Main), evitando acoplamientos innecesarios.

---

## ✨ Principios del proyecto

- Modularización real usando Swift Package Manager (local packages)
- Separación estricta entre App / Features / Core
- UI declarativa con SwiftUI
- Lógica de presentación con MVVM
- Infraestructura compartida centralizada en un AppContainer
- Persistencia segura con Keychain
- Networking desacoplado mediante protocolos
- Concurrencia moderna con Swift Concurrency

---

## 🧱 Estructura del repositorio

dinastia/
├── dinastia/                # App target (SwiftUI)
├── Core/                    # Infraestructura compartida
│   ├── CoreNetworking
│   ├── CoreModels
│   ├── CorePersistence
│   ├── AppContainer
│   └── DesignSystem (futuro)
├── Features/
│   ├── FeatureAuth
│   ├── FeatureRegister (futuro)
│   └── FeatureX
└── dinastia.xcodeproj

---

## 🧠 Arquitectura

El proyecto está dividido en tres capas principales:

### App
Responsable del arranque, routing principal y bootstrap inicial. No contiene lógica de negocio.

### Features
Cada feature es un módulo independiente con:
- Views (SwiftUI)
- ViewModels (estado y lógica)
- Flow como punto de entrada público

Las features no dependen entre sí.

### Core
Infraestructura compartida:
- Networking
- Persistencia
- Modelos
- Dependency Injection

---

## 🔌 Dependency Injection

Todas las dependencias se centralizan en `AppContainer`.

Ventajas:
- Código desacoplado
- Fácil testeo
- Escalabilidad

---

## 🔐 Flujo de autenticación

1. Usuario ingresa credenciales
2. LoginViewModel valida inputs
3. AuthAPI ejecuta login
4. Token se guarda en Keychain
5. App navega a Main

---

## 🌐 Networking

Implementado en CoreNetworking mediante APIClient y protocolos.
Las features nunca acceden directamente a URLSession.

---

## 🗝️ Persistencia

El token se guarda de forma segura usando Keychain.
Logout limpia el estado persistido.

---

## 🧵 Concurrencia

- UI y ViewModels usan @MainActor
- Networking y persistencia corren fuera del main thread

---

## ➕ Crear una nueva Feature

1. Crear package en Features
2. Definir FeatureFlow público
3. Consumir dependencias desde AppContainer

---

## 🧪 Testing

Preparado para mocks mediante protocolos.
Testing recomendado en ViewModels y Core.

---

## 📄 Licencia

Pendiente.
