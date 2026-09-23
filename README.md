# 📈 Crypto Portfolio App

A native iOS mobile application developed in **SwiftUI** that allows users to seamlessly track their favorite cryptocurrencies in real-time, simulate currency conversions, and securely log buy/sell transactions locally.

The project consumes the **CoinGecko API** using its Free Demo Plan and implements advanced mechanisms to protect against rate limiting (Error 429).

---

## ✨ Key Features

### 📱 Global Portfolio Screen
- **Consolidated Balance:** Total portfolio value in USD computed dynamically in real-time.
- **Donut Allocation Chart:** Built natively with **Swift Charts** to showcase asset distribution percentages alongside a synchronized color-coded legend.
- **Holdings List:** Direct navigation to your coin positions with reactive layout updates triggered by local database changes.

### 📊 Crypto Detail Screen
- **Interactive Time-Series Chart:** Seamless switching between **1D**, **7D**, and **30D** timeframes. Features a smooth gradient fill (*AreaMark*) and an interactive *Tooltip* powered by drag gestures to scan exact historical prices.
- **Market Metrics Grid:** Displays Market Cap, 24h Trading Volume, Circulating Supply, and All-Time Highs (ATH) formatted with professional, compact financial notation (e.g., `$1.2B`, `$45.3M`).
- **Bidirectional Calculator:** Instant conversion between the crypto asset and USD utilizing field isolation (`@FocusState`) to completely eliminate cross-field typing bugs.

### 💼 Transaction Ledger
- **SwiftData Persistence:** Modern on-device storage for logging trades (Buy/Sell operations).
- **Position Tracking:** Automatically computes token balances, net dollar exposure, average buy price, and real-time Profit & Loss (P&L).
- **Native User Experience:** Sheet-based input modals and intuitive Swipe-to-Delete lists.

---

## 🛠️ Architecture and Tech Stack

The project strictly follows the **MVVM (Model-View-ViewModel)** architectural pattern, enforcing solid separation of concerns and modular user interface design:

- **SwiftUI + Swift Charts:** For declarative layouts and fluid, financial-grade UI animations (iOS 17+).
- **SwiftData:** For lightweight relational data persistence without heavy CoreData boilerplate.
- **Concurrency (Async/Await):** Modern thread management for parallel network requests without locking the UI.
- **Dependency Injection:** SOLID principles applied by decoupling the generic network client (`NetworkManager`) from domain-specific operations (`APIServices`).

---

## ⚙️ Setup and Installation

### Prerequisites
- **Xcode 15.0** or higher.
- **iOS 17.0** or higher on your testing device or simulator.
- A free CoinGecko API Demo Plan key.

### Quick Start
1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com
   ```
2. Open the project in Xcode by double-clicking the `.xcodeproj` file.
3. Navigate to the `NetworkManager` class inside the Networking layer.
4. Replace the placeholder value of the `apiKey` variable with your private CoinGecko credentials:
   ```swift
   private let apiKey = "YOUR_API_KEY_HERE"
   ```
5. Select a simulator (e.g., iPhone 15 Pro) and press **`⌘ + R`** to compile and launch the application.

---

## 🛡️ Rate Limiting Strategy (Error 429)

Since CoinGecko's Free Demo Plan limits requests to 100 calls per minute, this app implements a three-tier mitigation system:
1. **Segmented Memory Caching:** `APIServices` caches chart and market responses for 5 minutes using composite dictionary keys (e.g., `"bitcoin-7D"`).
2. **Bulk-Group Peticiones:** The main portfolio dashboard unifies multiple holdings into a single query string (`/coins/markets?ids=bitcoin,ethereum,solana`), avoiding sequential HTTP calls.
3. **Explicit Error Handling:** Intercepts status code 429 globally within the generic network manager to gracefully alert the user.

---

## 🧪 Unit and UI Testing

The application includes a comprehensive automated test suite:

- **Unit Tests (`XCTest`):** Validate the accuracy of portfolio balance math, cache expiration logic, and `Double` formatting extensions. Uses a protocol-based `MockNetworkManager` to isolate the app from actual internet connections.
- **UI Tests (`XCUIApplication`):** Simulate actual user keyboard input on the currency converter fields to ensure responsive focus and focus-trapping behavior.

To run the entire test suite inside Xcode, use the keyboard shortcut **`⌘ + U`**.

---

## 📝 License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

