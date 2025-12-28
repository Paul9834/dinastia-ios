# Dinastía iOS — README (Arquitectura + lo que hicimos hoy)

> Objetivo del día: dejar **login real funcionando**, con una base **profesional y escalable** para seguir construyendo features sin romper todo a futuro.

---

## ✅ Resultado de hoy (en una frase)
Montamos una arquitectura **SPM modular + MVVM + DI (AppContainer)**, arreglamos problemas de **Swift tools / platform versions / products**, y dejamos **login + token en Keychain** funcionando.

---

## 1) Arquitectura que quedó (visión general)

### Capas / responsabilidades

- **App (Target `dinastia`)**
  - Decide el flujo principal (Auth vs Main) y la navegación.
  - No debe contener lógica de negocio.

- **FeatureAuth**
  - UI de login: `LoginView`
  - Lógica/estado de pantalla: `LoginViewModel`
  - Orquestación del feature: `AuthFlow`

- **AppContainer (DI / Dependency Injection)**
  - “Fábrica” de dependencias compartidas.
  - Expone: `apiClient`, `authAPI`, `tokenStore`, `AppConfig`.
  - Evita que cada feature cree infraestructura por su cuenta.

- **CoreNetworking**
  - HTTP client: `APIClient`
  - Modelos de request: `Endpoint`, `HTTPMethod`
  - Errores: `NetworkError`
  - Implementación auth: `AuthAPI` / `AuthAPIProtocol`

- **CoreModels**
  - DTOs (data transfer objects) compartidos:
    - `LoginRequest`, `LoginResponse`
    - `RegisterRequest`, `RegisterResponse`

- **CorePersistence**
  - Persistencia segura del token:
    - `TokenStore`
    - `KeychainTokenStore`

- **DesignSystem / CoreFoundationKit**
  - Base UI y helpers para estandarizar estilos y utilidades (listo para crecer).

---

## 2) Módulos y dependencias (cómo se conectan)

### “Mapa del sistema”

```
dinastia (App target)
  └── RootView
        ├── AuthFlow (FeatureAuth)
        │     └── LoginViewModel (@MainActor)
        │           ├── AuthAPIProtocol (CoreNetworking)
        │           └── TokenStore (CorePersistence)
        └── MainFlow (App)
```

### Cableado real
`AuthFlow` construye el feature usando dependencias de:

```
AuthFlow -> AppContainer.shared -> (authAPI, tokenStore)
```

**Esto te deja listo para:**
- Mocks para pruebas (AuthAPI fake, TokenStore fake).
- Reutilizar infraestructura en más features.
- Mantener dependencias controladas.

---

## 3) Bloqueos grandes que resolvimos hoy (y por qué pasaban)

### A) Swift tools version vieja (3.1.0)
**Síntoma**
- `package.swift is using Swift tools version 3.1.0 ...`

**Arreglo**
- En todos los `Package.swift`:
  - `// swift-tools-version: 6.2`

---

### B) Platform mismatch (CoreModels iOS 17 vs app iOS 12)
**Síntoma**
- `CoreModels requires minimum iOS 17.0 ... but target supports 12.0`

**Arreglo**
- Alinear **iOS mínimo = 17** en:
  - App target (Deployment Target)
  - **Todos** los packages (SPM):
    - `platforms: [.iOS(.v17)]`

---

### C) Missing package product / Packages duplicados
**Síntoma**
- `Missing package product 'DesignSystem'` / `FeatureAuth` / etc.
- Duplicados en Build Phases.

**Arreglo**
- Asegurar `products: [.library(...)]` en cada package.
- Limpiar duplicados en:
  - Build Phases → **Link Binary With Libraries**
- Re-resolver paquetes (Xcode reindex).

---

### D) Concurrencia / Actor isolation (data races)
**Síntoma**
- Warnings tipo: “Sending main actor-isolated ... risks data races”

**Decisión aplicada**
- **ViewModel/UI** en `@MainActor` (estado de UI)
- **Networking** NO amarrado al `@MainActor`

---

## 4) Flujo de autenticación que quedó funcionando

1. Usuario toca **INGRESAR**
2. `LoginView` dispara `Task { await viewModel.loginTapped() }`
3. `LoginViewModel` valida inputs y prende loading
4. Llama backend: `authAPI.login(LoginRequest(...))`
5. Recibe token y lo guarda:
   - `tokenStore.save(token)` (Keychain)
6. Llama `onAuthed()` → Root cambia a `.main`

---

## 5) Qué significaba el log del token

Ejemplo:
```
LoginTapped email=...
🟢 Token recibido: eyJhbGciOiJI… len=180
🟢 Token en Keychain: eyJhbGciOiJI…
```

- **Token recibido**: backend devolvió un JWT (normal que empiece con `eyJ...`)
- **len=180**: longitud del token (normal)
- **Token en Keychain**: confirma guardado y lectura exitosa ✅

---

## 6) Lo que ya tienes en el repo (módulos)

Packages locales:
- `AppContainer`
- `CoreFoundationKit`
- `CoreModels`
- `CoreNetworking`
- `CorePersistence`
- `DesignSystem`
- `FeatureAuth`

**Conclusión:** base “nivel empresa”, lista para crecer.

---

## 7) Reglas de oro para el futuro del proyecto

1. **Features aisladas**
   - FeatureX depende de: `Core*` + `DesignSystem` + `AppContainer`.

2. **App target solo enruta**
   - RootView/Flows/navegación, no lógica pesada.

3. **iOS mínimo alineado**
   - Si subes el mínimo en un package, sube en todo el grafo.

4. **Token = sesión**
   - Auto-login si existe token.
   - Logout = `tokenStore.clear()`.

---

## 8) Próximos pasos recomendados (orden pro)

1. **Auto-login**
   - En Root/Splash: si `tokenStore.load() != nil` → ruta `.main`

2. **Logout real**
   - Botón logout: `tokenStore.clear()` + ruta `.auth`

3. **Authorization header**
   - Agregar `Authorization: Bearer <token>` automáticamente en requests.

4. **Nuevo feature (ej. Pets)**
   - Replicar patrón: Flow → View → ViewModel → API → DTOs.

5. **DesignSystem real**
   - Extraer UI común: botones, inputs, spacing, glass helpers, colores.

---

## 9) Plantilla mental para crear FeatureX

- `FeatureXFlow`: crea VM con `AppContainer`
- `XViewModel (@MainActor)`: estado UI + acciones async
- `XView`: UI pura
- `XAPIProtocol + XAPI` en `CoreNetworking`
- `XRequest/XResponse` en `CoreModels`
- `Stores` en `CorePersistence` si se necesita

---

## ✅ Estado actual
- ✅ Login funciona
- ✅ Token guardado en Keychain
- ✅ Packages alineados (tools + iOS mínimo)
- ✅ Arquitectura lista para escalar
