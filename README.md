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
<img width="350" height="700" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-13 at 16 36 17" src="https://github.com/user-attachments/assets/7ebf9462-bc74-4e86-bbd9-e7ac27e94fd9" />
<img width="350" height="700" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-13 at 16 36 12" src="https://github.com/user-attachments/assets/eace2232-3f14-41ea-8965-f58e41f18354" />
<img width="350" height="700" alt="Simulator Screenshot - iPhone 16 Pro - 2025-09-13 at 16 36 09" src="https://github.com/user-attachments/assets/3d43e50c-443e-4383-8306-4fd61756ef66" />

