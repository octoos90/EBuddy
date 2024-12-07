
# EBuddy iOS

EBuddy iOS is a mobile application built using Swift and SwiftUI, following the **Model-View-ViewModel (MVVM)** architecture. The app integrates Firebase for backend services and is designed to support existing website users while ensuring a clean and scalable codebase.

## Table of Contents

- [Features](#features)
- [Setup](#setup)
  - [Prerequisites](#prerequisites)
  - [Firebase Configuration](#firebase-configuration)
  - [Installation](#installation)
- [Architecture](#architecture)
- [Development Workflow](#development-workflow)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### Firebase Integration
- Firestore setup with document handling for user data.
- Firebase Storage for uploading and displaying user profile images.
- Firebase Authentication for user management.

### Mock Environments
- Development and staging environments with basic configurations.

### User Data Handling
- Integration of `UserJSON` entity from Next.js into the app.
- Display user details:
  - Gender
  - Phone number
  - Email
  - UID

### Profile Image Upload
- Upload user profile images via Firebase Storage.
- Support for background uploads, even when navigating away from the screen.

### Global State Management
- Real-time global access to user data (`UserJSON`) with UI updates upon changes.

### Figma Design Implementation
- SwiftUI code translated from Figma designs.
- Fully supports dark mode.

### Firestore Advanced Queries
- Fetch user data based on multiple conditions:
  1. Recently active (descending order).
  2. Highest rating (descending order).
  3. Female users only.
  4. Lowest service pricing (ascending order).

---

## Setup

### Prerequisites
- Xcode (latest stable version).
- Swift Package Manager for dependencies.
- Firebase account and project setup.

### Firebase Configuration
To test the app, you must create your own Firebase project:

1. Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
2. Enable the following Firebase services:
   - Firestore Database
   - Firebase Authentication
   - Firebase Storage
3. Download your `GoogleService-Info.plist` file from the Firebase Console and add it to the Xcode project:
   - Drag and drop the file into the Xcode project under the `Runner` group.
   - Ensure the file is added to all targets in your project settings.
4. Set up a Firestore collection named `USERS` with the following structure:
   - Collection: `USERS`
     - Document ID: (Firebase-generated UUID)
       - Fields:
         - `uid`: String
         - `ge`: Number (0 for female, 1 for male)
         - `email`: String
         - `phoneNumber`: String

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/EBuddy-iOS.git
   cd EBuddy-iOS
   ```

2. Install dependencies using Swift Package Manager:
   - Open the project in Xcode.
   - Go to **File > Add Packages**.
   - Add the following dependencies:
     - `https://github.com/firebase/firebase-ios-sdk`

3. Run the project:
   ```bash
   open EBuddy.xcodeproj
   ```

---

## Architecture

EBuddy follows the **MVVM (Model-View-ViewModel)** pattern:

- **Model**:
  - Represents the application data and business logic, e.g., `UserJSON`.

- **ViewModel**:
  - Acts as a bridge between the View and Model, managing state and logic.

- **View**:
  - Built with SwiftUI, focuses solely on the UI layer.

This structure ensures code scalability, reusability, and ease of maintenance.

---

## Development Workflow

### Commit Details
1. **Firebase Setup**: Configure Firestore, Storage, and Authentication.
2. **Mock Environments**: Basic development and staging setups.
3. **UserJSON Implementation**: Ported `UserJSON` from Next.js to SwiftUI.
4. **Profile Image Upload**: Enabled uploading and displaying profile images.
5. **Background Upload Task**: Added support for background uploads.
6. **Global State Management**: Enabled global user data access.
7. **Figma Integration**: Converted Figma designs to SwiftUI views.
8. **Dark Mode Support**: Implemented dark mode.
9. **Advanced Firestore Queries**: Added multi-criteria querying.

---

## Contributing

Contributions are welcome! Follow these steps:
1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of changes"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Create a Pull Request.

---

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

---
