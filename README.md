# 📱 CryptoTracker App

[![Swift](https://shields.io)](https://swift.org)
[![iOS](https://shields.io)](https://apple.com)
[![SwiftUI](https://shields.io)](https://apple.com)
[![SwiftData](https://shields.io)](https://apple.com)
[![Architecture](https://shields.io)]()

### 📄 Description
**CryptoTracker App** is a native iOS mobile application built to track favorite cryptocurrencies in real-time. The project implements live portfolio tracking, local trade simulations, and a robust defense strategy against API rate limiting. 

This repository showcases production-ready architecture using modern Apple frameworks, focus-trapping UI validation, and financial-grade interactive charts.

---

### 📸 UI/UX Preview

| Crypto List | Crypto Analytics | Transaction Ledger | Global Graphic |
| ---------------- | ---------------- | ------------------ | ------------------ |
| <img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-09-24 at 14 10 49" src="https://github.com/user-attachments/assets/4d5e2933-9011-4e2a-80aa-30107db55769" /> | <img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-09-24 at 14 11 00" src="https://github.com/user-attachments/assets/43d27f75-92b7-4464-be00-48323ffe0d4d" /> | <img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-09-24 at 14 11 16" src="https://github.com/user-attachments/assets/6fd9a04b-bc8e-431a-b222-d57d121fe83a" /> | <img width="220" alt="Simulator Screenshot - iPhone 17 Pro - 2026-09-24 at 14 53 34" src="https://github.com/user-attachments/assets/e578bbb0-d011-4295-b911-9242a16c80fa" /> |

---

### ⚙️ Core Architecture & Key Concepts

*   **MVVM Architecture:** Solid separation of concerns. ViewModels manage reactive UI state transitions while keeping business logic decoupled from the layout.
*   **Dependency Injection:** Enforces SOLID principles by fully decoupling the generic networking layer (`NetworkManager`) from domain-specific actions (`APIServices`).
*   **Modern Concurrency:** Native integration of `async/await` for parallel, non-blocking HTTP requests.
*   **Reactive Persistence:** Powered by **SwiftData** to handle on-device relational storage with seamless view updates triggered by database changes.

---

### 📦 Application Modules

#### 📊 1. Global Dashboard
*   **Consolidated Balance:** Live portfolio value calculation in USD computed dynamically.
*   **Donut Allocation Chart:** Built with **Swift Charts** to showcase asset distribution alongside a synchronized color-coded legend.
*   **Reactive Holdings:** Direct navigation to active coin positions with auto-updating list states.

#### 📈 2. Crypto Analytics & Detail
*   **Time-Series Charts:** Interactive historical price tracking across **1D**, **7D**, and **30D** timeframes utilizing custom gradient fills (`AreaMark`).
*   **Gesture Tooltip:** Drag-gestures enabled to scan exact price entries and historical timestamps.
*   **Market Metrics Grid:** Clear presentation of Market Cap, Volume, Supply, and ATH formatted with compact financial notation (e.g., `$1.2B`).
*   **Bidirectional Calculator:** Bug-free currency conversion using isolated `@FocusState` inputs.

#### 💼 3. Transaction Ledger & Math Engine
*   **Trade Logging:** Local logging of Buy/Sell operations backed by SwiftData models.
*   **Position Tracker:** Automated tracking for token balances, net dollar exposure, average buy price, and real-time Profit & Loss (P&L).
*   **Native UX:** Intuitive sheet-based modal inputs and responsive swipe-to-delete flows.

---

### 🛡️ Rate Limiting Strategy (Error 429 Mitigation)
To prevent hitting limits on CoinGecko's Free Demo Plan (100 calls/min), the architecture integrates a three-tier mitigation system:
1.  **Segmented Memory Caching:** `APIServices` caches chart and market metrics for 5 minutes via composite dictionary keys (e.g., `"bitcoin-7D"`).
2.  **Bulk-Group Queries:** The main dashboard groups multiple assets into unified query strings (`/coins/markets?ids=bitcoin,ethereum`), preventing sequential request spam.
3.  **Explicit Interception:** Catches HTTP Status 429 globally in the network pipeline to trigger user-friendly UI degradation gracefully.

---

### 🧪 Automated Testing Suite
The application includes a comprehensive test suite validating both logic accuracy and user interactions:

*   **Unit Tests (`XCTest`):** Verifies portfolio math formulas, cache expiration rules, and financial formatting extensions. Leverages a protocol-based `MockNetworkManager` for isolated environment testing.
*   **UI Tests (`XCUIApplication`):** Simulates keyboard input on conversion fields to guarantee focus-trapping behaviors work seamlessly.

To run the complete test suite, open Xcode and hit `CMD + U`.

---

### 🛠️ Tech Stack

*   **Language:** Swift 5.10+ (`async/await`)
*   **UI Framework:** SwiftUI (iOS 17.0+ Minimum Target)
*   **Data Visualization:** Swift Charts
*   **Persistence Layer:** SwiftData
*   **Networking:** URLSession (CoinGecko API)
*   **Testing Framework:** XCTest / XCUITest

---

### 🚀 Getting Started

#### Prerequisites
*   Xcode 15.0 or higher.
*   iOS 17.0+ Simulator or physical device.
*   A free CoinGecko API Demo Key.

#### Quick Start
1. Clone this repository:
   ```bash
   git clone https://github.com
   ```
2. Open the project root directory and launch the Xcode project:
   ```bash
   cd CryptoTracker
   open CryptoTracker.xcodeproj
   ```
3. Open `NetworkManager.swift` and replace the placeholder API key with your own:
   ```swift
   private let apiKey = "YOUR_API_KEY_HERE"
   ```
4. Choose an iOS 17.0+ simulator target and press `CMD + R` to build and run.

---

### 👨‍💻 Author

Developed by **Your Name**
*   **LinkedIn:** [Your Profile](https://linkedin.com)
*   **Portfolio:** [Your Website](https://yourwebsite.com)
*   **Email:** your.email@example.com
