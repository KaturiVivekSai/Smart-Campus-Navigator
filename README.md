# Smart Campus Navigator

A premium, interactive Flutter application designed to simplify navigation within a college campus. The app provides a seamless experience for students, staff, parents, and guests, featuring a multi-floor interactive map and role-based access.

## ✨ Key Features

### 1. Interactive Splash Screen
- **Pulsing Logo**: Smooth animations for a modern feel.
- **Fast Loading**: 0-100% progress tracking in under 2 seconds.

### 2. Role-Based Authentication
- **Tailored Experience**: 4 distinct user roles (Student, Staff, Parent, Guest).
- **Direct Login**: Parents and Guests can access maps immediately without credentials.
- **Secure Access**: Robust validation and secure logout redirection for Students and Staff.

### 3. Dynamic Interactive Map
- **Indoor Navigation**: Navigate specifically within the campus across **3 floors**.
- **Pathfinding**: High-visibility green paths to indoor locations (e.g., Computer Lab 3 on Floor 3).
- **Live Guidance**: Simulated user movement along paths with voice and mic integration.
- **Smart UI**: Auto-hiding navigation bars during active travel for a focused experience.

### 4. Smart Search & Discovery
- **Voice Search**: Integrated mic for hands-free location discovery.
- **Recent Places**: Quickly return to frequently visited spots.
- **Quick Categories**: Explore labs, libraries, offices, and more.

### 5. Campus Help & Profile
- **Feedback Center**: Functional form to submit suggestions and report issues with success alerts.
- **Profile Management**: Modern edit profile functionality and saved locations.
- **App Settings**: Customizable app preferences including font size and style.

## 🛠️ Technology Stack
- **Framework**: Flutter (Dart)
- **State Management**: StatefulWidget with TickerProvider (Animations)
- **UI Design**: Material 3 with Custom Drawing (Canvas)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Android Studio or VS Code with Flutter extension

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/smart-campus-navigator.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## 📂 Project Structure
- `lib/screens/`: Contains all 9 functional screens.
- `lib/main.dart`: App entry point and routing logic.
- `lib/services/`: Mock authentication and campus data services.

---
*Developed for a smarter, more connected campus experience.*
