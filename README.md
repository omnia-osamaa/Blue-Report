# 📱 Blue Report - Gamified Waste Incident Reporting System

[![Flutter Version](https://img.shields.io/badge/Flutter-%5E3.7.0-blue.svg?style=flat&logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%5E3.7.0-blue.svg?style=flat&logo=dart)](https://dart.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green.svg?style=flat)](#-system-architecture)
[![State Management](https://img.shields.io/badge/State%20Management-Bloc%20/%20Cubit-purple.svg?style=flat)](https://pub.dev/packages/flutter_bloc)

**Blue Report** is a state-of-the-art Flutter mobile application engineered to empower citizens to report waste accumulations and environmental hazards in their communities. Combining **Clean Architecture** principles with a **Gamified Reward System**, the application incentivizes community cleanups by offering point accumulations that can be redeemed for eco-friendly products or converted directly to cash via mobile wallets.

---

## 🌟 Key Features

*   🔍 **National ID OCR Scanning**: Automated citizen verification via mobile camera/gallery scan of National ID cards, utilizing server-side OCR to generate unique setup tokens for secure, verified user registration.
*   📸 **Waste Incident Reporting**: Capture or upload photos of waste accumulations, select waste categories (Plastic, Organic, Glass, etc.), and provide descriptions.
*   📍 **Automated GPS Tagging**: Native integration with device geolocators to automatically fetch coordinates (Latitude/Longitude) for precise waste location mapping.
*   🎮 **Eco-Warrior Gamification**: Active level progression, points systems, and badging (e.g., "Beginner", "Eco Supporter", "Eco Warrior") based on approved waste reports.
*   📊 **Eco Impact Tracker**: A personalized visualization dashboard reflecting the user's positive ecological contribution and waste reduction footprint.
*   💰 **Points-to-Cash & Reward Store**:
    *   **In-app Store**: Redeem physical products using earned points with dynamic shipping fee calculations.
    *   **Mobile Wallet Cashout**: Withdraw earnings directly to local wallets (Vodafone Cash, Orange Cash, Etisalat Cash).
*   🔔 **Notifications Center**: Integrated Firebase Cloud Messaging (FCM) for real-time status updates (Acceptance/Rejection notes) on waste reports.

---

## 🏗️ System Architecture

The application strictly implements **Clean Architecture** to enforce separation of concerns, scalability, and testability.

```
                     ┌──────────────────────────────────────────────┐
                     │              Presentation Layer              │
                     │  (UI Pages, Custom Widgets, BLoC/Cubits)    │
                     └──────────────────────┬───────────────────────┘
                                            │
                                            ▼ Uses Usecases
                     ┌──────────────────────────────────────────────┐
                     │                 Domain Layer                 │
                     │  (Entities, Usecase Logic, Repo Interfaces)  │
                     └──────────────────────┬───────────────────────┘
                                            ▲
                                            │ Implements Interfaces
                     ┌──────────────────────┴───────────────────────┐
                     │                  Data Layer                  │
                     │   (Models, Remote & Local Datasources,       │
                     │        Repository Implementations)           │
                     └──────────────────────────────────────────────┘
```

*   **Domain Layer**: Completely isolated business rules containing entities ([User](lib/features/auth/domain/entities/user.dart), [Report](lib/features/home/report/domain/entities/report.dart)), usecases ([CreateReportUseCase](lib/features/home/report/domain/usecases/create_report_usecase.dart)), and repository contracts.
*   **Data Layer**: Contains API consumers ([DioConsumer](lib/core/api/dio_consumer.dart)), model classes implementing JSON serializers (`UserModel`, `ReportModel`), remote datasources, and repository implementations managing data flow.
*   **Presentation Layer**: Declarative Flutter widgets utilizing [ScreenUtil](https://pub.dev/packages/flutter_screenutil) for screen responsiveness, managed by `flutter_bloc` state machines ([AuthCubit](lib/features/auth/presentation/bloc/auth_cubit.dart), [ReportCubit](lib/features/home/report/presentation/bloc/report_cubit.dart), [RewardCubit](lib/features/home/report/presentation/bloc/reward_cubit.dart)).

---

## 🛠️ Tech Stack & Dependencies

*   **State Management**: `flutter_bloc` (Cubit)
*   **Service Locator / DI**: `get_it`
*   **Network Interface**: `dio` (with Bearer Auth interceptors & `pretty_dio_logger`)
*   **Database / Cache**: `shared_preferences`
*   **Localization**: `easy_localization` (supporting EN & AR)
*   **Push Notifications**: `flutter_local_notifications` & Firebase Messaging (FCM)
*   **Location Services**: `geolocator` & `geocoding`
*   **Hardware Control**: `image_picker` (Camera/Gallery)
*   **UI Helpers**: `smooth_page_indicator`, `cached_network_image`, `flutter_screenutil`

---

## ⚙️ Setup & Installation

### Prerequisites
Make sure you have Flutter SDK installed on your machine (`^3.7.0`). Run `flutter doctor` to ensure your environment is set up.

### Step-by-Step Guide

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/yourusername/blue-report.git
    cd blue-report
    ```

2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configure API Base URL**:
    Navigate to [app_config.dart](lib/core/config/app_config.dart) and configure the backend service endpoint:
    ```dart
    class AppConfig {
      static const String baseUrl = 'http://187.124.12.183:8090'; // Change to your local/staging API URL
      // ...
    }
    ```

4.  **Run the Project**:
    *   **Development / Run**:
        ```bash
        flutter run
        ```
    *   **Build Release APK**:
        ```bash
        flutter build apk --release
        ```

---

## 📊 Technical Flow Diagram

### Core Sequence Flow (Authentication, Incident Reporting, Cash Conversion)
Below is the data lifecycle map illustrating communications across UI, Cubit managers, local memory cache, and backend server endpoints:

![Sequence Flow Diagram](sequence_image/combined_flow.png)

---

## 🤝 Project Contribution Guidelines

1.  Create an issue explaining the feature or bugfix.
2.  Fork this repository.
3.  Create a feature branch (`git checkout -b feature/NewFeature`).
4.  Commit your changes following standard commit messages (`git commit -m 'Add new feature'`).
5.  Push to the branch (`git push origin feature/NewFeature`).
6.  Open a Pull Request.

---

## 📄 License
This project is licensed under the MIT License - see the `LICENSE` file for details.
