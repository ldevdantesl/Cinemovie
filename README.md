<div align="center">

<img width="120" height="120" alt="App Icon Transparent" src="https://github.com/user-attachments/assets/9476b086-8a09-4e80-957d-96e948b2fd86" />


# Cinemovie

**Your Personal Movie & TV Companion**

Discover movies and TV shows, explore cast and crew, build personal watchlists, and never lose track of what to watch next.

[![Platform](https://img.shields.io/badge/platform-iOS%2015.0%2B-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Architecture](https://img.shields.io/badge/architecture-VIPER-green.svg)](#architecture)
[![License](https://img.shields.io/badge/license-Proprietary-red.svg)](LICENSE)

[Download on the App Store](https://apps.apple.com/app/id6761709306) · [Report a Bug](mailto:ldevdantesl@gmail.com) · [Request a Feature](mailto:ldevdantesl@gmail.com)

</div>

---

## Overview

Cinemovie is a native iOS application that provides a clean, fast, distraction-free way to discover movies and TV shows, explore the people behind them, and keep track of everything you want to watch. Built natively for iOS using UIKit and the VIPER architecture.

## Screenshots

<div align="center">
  
<img width="200" height="2778" alt="Intro" src="https://github.com/user-attachments/assets/f17737db-f9ff-4a8b-bb8c-9db0a84c1d5c" />
<img width="200" height="2778" alt="Discover" src="https://github.com/user-attachments/assets/bb8a6a8d-71ee-4793-b28f-6aa15a9836e9" />
<img width="200" height="2778" alt="Lists" src="https://github.com/user-attachments/assets/a5a7a2e6-56df-4617-9506-d53e735b1f7b" />
<img width="200" height="2778" alt="Favorites" src="https://github.com/user-attachments/assets/f2d36f7e-c32a-434c-890c-0a4d87ad312f" />
<img width="200" height="2778" alt="Person" src="https://github.com/user-attachments/assets/83338549-b119-428c-8baa-dd5b652dc47f" />
<img width="200" height="2778" alt="Settings" src="https://github.com/user-attachments/assets/886cc8a7-149b-4dd9-9f75-7ef9760b1c6d" />

</div>

## Features

### Discover
- Browse trending movies and TV shows updated in real time
- Explore now-playing films, top-rated content, and curated genre collections
- Discover trending people and rising stars
- Switch seamlessly between movies and TV shows

### Detailed Information
- Comprehensive details for every movie and TV show: synopsis, runtime, seasons, production companies, and country of origin
- Full cast and crew with character names
- Person profiles with biographies, filmographies, and links to Wikipedia and IMDb
- Community reviews and ratings
- Personalized recommendations based on what you're watching

### Personal Lists
- Save titles to your Watchlist and Favorites
- Create unlimited custom lists for any mood or occasion
- Public and private list support
- Rate movies and TV shows
- Track recently viewed media

### Search
- Fast, responsive search across movies, TV shows, and people
- Recent search history
- Smart filtering and result ranking

### Personalization
- Multi-language support
- Region-based content filtering
- Default media type selection
- Notification preferences
- Adult content filtering

## Architecture

Cinemovie is built using the **VIPER architecture pattern** with a clear separation of concerns:

```
Module/
├── View         → UIViewController & UI components
├── Interactor   → Business logic & data fetching
├── Presenter    → View ↔ Interactor coordination
├── Entity       → Data models
└── Router       → Navigation & module assembly
```

### Key Architectural Patterns
- **VIPER** for module structure and separation of concerns
- **DIContainer** for dependency injection across modules
- **Coordinator pattern** for navigation flow management
- **Diffable Data Sources** with `UICollectionViewCompositionalLayout`
- **Structured Concurrency** (`async/await`, `withTaskGroup`) for parallel data fetching
- **Protocol-Oriented Programming** for testability and modularity
- **AuthService layer** for centralized authentication management

### Tech Stack
- **Language:** Swift 5.9
- **UI Framework:** UIKit
- **Architecture:** VIPER, MVVM
- **Layout:** SnapKit, CompositionalLayout
- **Concurrency:** async/await, Combine
- **Networking:** URLSession with custom Network Service layer
- **Persistence:** Core Data, Keychain
- **API:** TMDB v3 & v4
- **Minimum iOS:** 15.0

## Project Structure

```
Cinemovie/
├── App/                    → App entry point & configuration
├── Core/                   → Shared utilities, extensions, constants
├── Networking/             → Network layer, endpoints, auth services
├── Services/               → User service, storage, configuration
├── Modules/
│   ├── Discover/           → Discover screen (VIPER module)
│   ├── MovieDetails/       → Movie details (VIPER module)
│   ├── SeriesDetails/      → TV series details (VIPER module)
│   ├── PersonDetails/      → Person details (VIPER module)
│   ├── Search/             → Search screen (VIPER module)
│   ├── MyLists/            → Personal lists (VIPER module)
│   └── Settings/           → Settings & preferences (VIPER module)
├── Resources/              → Assets, fonts, localizations
└── PrivacyInfo.xcprivacy   → Privacy manifest
```

## Highlights

- **Three published App Store apps** by the same developer (Cinemovie, EduConnect, AimIt)
- **Native iOS** — built from the ground up with UIKit, no cross-platform shortcuts
- **Production-grade architecture** — VIPER, DIContainer, Coordinator pattern
- **Modern Swift** — async/await, structured concurrency, Swift 6 strict concurrency compliant
- **Privacy-first** — full Privacy Manifest support per Apple's latest requirements
- **Real backend integration** — TMDB v3/v4 OAuth flows with persistent sessions

## API Attribution

This product uses the TMDB API but is not endorsed or certified by [TMDB](https://www.themoviedb.org/).

## Roadmap
- [ ] Widget support
- [ ] Siri Shortcuts integration
- [ ] Offline mode for watchlists

## About the Developer

Built by **Buzurgmehr Rakhimzoda (Dantes)** — Native iOS Developer with 4+ years of experience.

- 🌐 [GitHub](https://github.com/ldevdantesl)
- 💼 [LinkedIn](https://www.linkedin.com/in/buzurgmehr-rahimzoda-5789a1248/)
- 📧 ldevdantesl@gmail.com
- 📍 Alexandria, VA, USA

### Other Apps
- **EduConnect** — Trilingual university guide for Kazakhstan students
- **AimIt** — Goal tracking app built with SwiftUI + Clean Architecture

## License

**Copyright © 2026 Buzurgmehr Rakhimzoda. All Rights Reserved.**

This project is proprietary software. The source code is made publicly available for **portfolio and viewing purposes only**. No part of this codebase may be copied, modified, distributed, or used in any form without the express written permission of the copyright holder.

See [LICENSE](LICENSE) for full terms.

---

<div align="center">

**If you find this project interesting, please ⭐ the repo!**

Made with ❤️

</div>
