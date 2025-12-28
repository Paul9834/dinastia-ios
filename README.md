Dinastía iOS — README GENERAL (lo que hicimos hoy + arquitectura actual)

============================================================
0) Resultado de hoy (en una frase)
============================================================
Dejamos el proyecto funcionando con login real y una arquitectura modular (SPM) con MVVM + DI (AppContainer).
También resolvimos problemas de Swift tools version, platform versions y productos faltantes en el grafo de paquetes.
El token se recibe del backend y se guarda en Keychain (CorePersistence).

============================================================
1) Arquitectura que quedó (visión general)
============================================================

Capas / responsabilidades

- App (Target dinastia)
  - Decide el flujo (Auth vs Main) y la navegación.
  - No debe contener lógica de negocio.

- FeatureAuth
  - UI de login (LoginView)
  - Estado/lógica de pantalla (LoginViewModel)
  - Orquestador del feature (AuthFlow)

- AppContainer (DI / “Dependency Injection”)
  - Fábrica/registro de dependencias compartidas.
  - Expone authAPI, tokenStore, apiClient, config, etc.
  - Centraliza la creación de objetos para que las Features no construyan infraestructura.

- CoreNetworking
  - Cliente HTTP (APIClient)
  - Endpoint + HTTPMethod + NetworkError
  - Implementación de AuthAPI/AuthAPIProtocol
  - Decodificación JSON y manejo de respuestas

- CoreModels
  - DTOs compartidos (LoginRequest/LoginResponse, RegisterRequest/RegisterResponse, etc.)
  - Son “modelos de transporte” (lo que viaja por red).

- CorePersistence
  - TokenStore (Keychain) para guardar/leer/borrar token
  - KeychainTokenStore + errores de Keychain

- DesignSystem / CoreFoundationKit
  - Base UI y helpers para estandarizar estilos/componentes (listo para crecer)
  - CoreFoundationKit puede alojar utilidades generales compartidas.

============================================================
2) Módulos y dependencias (cómo se conectan)
============================================================

Diagrama mental:

dinastia (App target)
  └── RootView
        ├── AuthFlow (FeatureAuth)
        │     └── LoginViewModel (@MainActor)
        │           ├── AuthAPIProtocol (CoreNetworking)
        │           └── TokenStore (CorePersistence)
        └── MainFlow (App)

Cableado real:
AuthFlow -> AppContainer.shared -> (authAPI, tokenStore)

Esto te permite:
- Cambiar implementaciones (por ejemplo AuthAPI mock, TokenStore mock) sin tocar la UI.
- Reutilizar infraestructura en más features.

============================================================
3) Problemas fuertes que resolvimos (y por qué pasaban)
============================================================

A) Swift tools version vieja (3.1.0)
----------------------------------
Síntoma:
- “package.swift is using Swift tools version 3.1.0 which is no longer supported”
- Xcode no resolvía CoreModels y cascada de paquetes.

Arreglo:
- En TODOS los Package.swift:
  // swift-tools-version: 6.2

B) Platform mismatch (CoreModels iOS 17 vs targets iOS 12)
----------------------------------------------------------
Síntoma:
- “The package product 'CoreModels' requires minimum platform version 17.0 for iOS, but this target supports 12.0”

Arreglo:
- Alinear el mínimo iOS a 17 en:
  1) App target (Build Settings -> iOS Deployment Target)
  2) TODOS los packages: platforms: [.iOS(.v17)]

C) Missing package product (DesignSystem/FeatureAuth/CoreNetworking/etc.)
------------------------------------------------------------------------
Síntoma:
- “Missing package product 'DesignSystem' ...”
- “Missing package product 'FeatureAuth' ...”

Causa típica:
- El Package.swift no exponía product o Xcode quedó con estados viejos.
- Duplicados o referencias incorrectas en Link Binary With Libraries.

Arreglo:
- Asegurar que cada paquete tenga:
  products: [.library(name: "...", targets: ["..."])]
- Limpiar duplicados en Build Phases > Link Binary With Libraries
- Re-resolver paquetes (Xcode lo vuelve a indexar bien después de limpiar)

D) Concurrencia / Data race (MainActor vs networking)
-----------------------------------------------------
Síntoma:
- Warnings de actor isolation (“Sending main actor-isolated ... risks data races”)

Decisión de hoy:
- ViewModel y UI en @MainActor (porque actualizan estado de UI)
- Networking NO amarrado a @MainActor (debe ser background-friendly)
- El VM llama a networking en Task async y luego actualiza estado (ya está en MainActor).

============================================================
4) Flujo de autenticación que quedó funcionando
============================================================

1) Usuario toca “INGRESAR”
- LoginView dispara:
  Task { await viewModel.loginTapped() }

2) ViewModel valida inputs
- recorta espacios, valida que no estén vacíos
- prende loading

3) ViewModel llama backend
- authAPI.login(LoginRequest(correo: e, contrasena: p))

4) Recibe token (JWT)
- ejemplo: “eyJhbGciOiJI…”
- se imprime log de debug para confirmar

5) Guarda token en Keychain
- tokenStore.save(token)

6) Notifica éxito y cambia el flow
- onAuthed() -> RootView cambia route a .main

============================================================
5) ¿Qué significa este log?
============================================================
LoginTapped email=...
🟢 Token recibido: eyJhbGciOiJI… len=180
🟢 Token en Keychain: eyJhbGciOiJI…

Interpretación:
- Token recibido: el backend respondió un JWT (normal que empiece con “eyJ”)
- len=180: longitud del token (normal)
- Token en Keychain: confirmación de que se guardó y se pudo leer
Conclusión:
- Login + persistencia quedaron OK.

============================================================
6) Estructura actual (lo que ya tienes)
============================================================

Packages locales:
- AppContainer
- CoreFoundationKit
- CoreModels
- CoreNetworking
- CorePersistence
- DesignSystem
- FeatureAuth

Esto es una base “nivel empresa”:
- escalable
- testeable
- fácil de mantener
- dependencias controladas

============================================================
7) Lo que debes entender para el futuro (reglas de oro)
============================================================

Regla #1: Features viven aisladas
- FeatureX solo depende de Core* + DesignSystem + AppContainer (para inyección)

Regla #2: El App target solo enruta
- RootView/Flows/Navegación, nada de lógica fuerte

Regla #3: Platform mínimo debe estar alineado
- Si un package sube iOS mínimo, todo el grafo debe alinearse

Regla #4: Token define sesión
- Token en Keychain permite:
  - auto-login
  - proteger rutas
  - logout = tokenStore.clear()

============================================================
8) Próximos pasos recomendados (orden lógico)
============================================================

1) Auto-login
- En Splash o Root: si tokenStore.load() != nil -> route = .main

2) Logout real
- Botón logout: tokenStore.clear() + route = .auth

3) Authorization header automático
- En APIClient: si hay token, agregar:
  Authorization: Bearer <token>

4) FeaturePets (siguiente feature)
- Repetir patrón: Flow -> View -> ViewModel -> API -> DTOs -> Persistence si aplica

5) DesignSystem real
- Extraer componentes UI (fieldPill, botones, colores, spacing, tipografías)
- Evitar duplicar UI en cada feature

============================================================
9) Plantilla mental para crear una nueva feature (FeatureX)
============================================================

- FeatureXFlow
  - Crea ViewModel e inyecta dependencias desde AppContainer

- XViewModel (@MainActor)
  - Estado UI + acciones (tapped), llama APIs y actualiza UI

- XView
  - UI pura, sin lógica pesada

- CoreNetworking
  - XAPIProtocol + XAPI

- CoreModels
  - XRequest/XResponse DTOs

- CorePersistence (si necesita storage)
  - Stores (Keychain, UserDefaults, archivos)

============================================================
Estado actual
============================================================
✅ Login funciona
✅ Token se guarda en Keychain
✅ Arquitectura modular lista para crecer
✅ Packages alineados (tools + iOS mínimo)

FIN
