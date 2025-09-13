# AuthApp

AuthApp is a demo iOS application built with **SwiftUI** that supports both **online and offline authentication**.  
It follows **Clean Architecture (Data / Domain / Presentation)** and leverages **Combine**, **Resolver (DI)**, and **CoreData**.

---

## 🚀 Features

- **Authentication Flow**:
  - Login (online and offline)
  - Registration (online only)
  - Password reset (online only)
- **Offline-first**:
  - User profile persisted in CoreData
  - Auto-login offline if the user was authenticated before
- **UI**:
  - SwiftUI + MVVM
  - Custom `TextField` and `PasswordField` (with keyboard accessory bar removed)
- **Dependency Injection**:
  - Powered by [Resolver](https://github.com/hmlongco/Resolver)
- **Networking**:
  - URLSession + Combine
  - Test APIs: [httpbin](https://httpbin.org) and [randomuser.me](https://randomuser.me)
- **Architecture**:
  - Data / Domain / Feature separation
  - Use Cases for business logic
  - Repositories for networking and persistence

