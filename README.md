# SpaceX App

[![Flutter Version](https://img.shields.io/badge/Flutter-3.35-blue.svg)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Mobile application built with Flutter that allows space enthusiasts to explore the history of SpaceX launches.
Track past and present launches, get technical details of rockets, launchpads and payloads, and keep your favorite missions just a tap away.

---

## ✨ Feature Showcase

###  Onboarding

<table align="center">
  <tr>
    <td align="center">
      <img src="screenshots/onboarding_1.png" height="500" alt="First page.">
    </td>
    <td align="center">
      <img src="screenshots/onboarding_2.png" height="500" alt="Second page.">
    </td>
    <td align="center">
      <img src="screenshots/onboarding_3.png" height="500" alt="Third page.">
    </td>
  </tr>
</table>

---

### Pinned Favorites

<div align="center">
      <img src="screenshots/favorites.png" height="500" alt="Favorites.">
</div>

---

### Grid/List view mode

<table align="center">
  <tr>
    <td align="center">
      <img src="screenshots/homelist.png" height="500" alt="List view.">
    </td>
    <td align="center">
      <img src="screenshots/homegrid.png" height="500" alt="Grid view.">
    </td>
  </tr>
</table>

---

### Search

<table align="center">
  <tr>
    <td align="center">
      <img src="screenshots/crew_search.png" height="500" alt="List search.">
    </td>
    <td align="center">
      <img src="screenshots/grid_search.png" height="500" alt="Grid search.">
    </td>
  </tr>
</table>

---

### Filter

<div align="center">
      <img src="screenshots/filters.png" height="500" alt="Filter.">
</div>

---

### Details

<table>
  <tr>
    <td align="center">
      <img src="screenshots/details_1.png" height="500" alt="Details 1.">
    </td>
    <td align="center">
      <img src="screenshots/details_2.png" height="500" alt="Details 2.">
    </td>
    <td align="center">
      <img src="screenshots/details_3.png" height="500" alt="Details 3.">
    </td>
    <td align="center">
      <img src="screenshots/details_4.png" height="500" alt="Details 4.">
    </td>
    <td align="center">
      <img src="screenshots/details_5.png" height="500" alt="Details 5.">
    </td>
    <td align="center">
      <img src="screenshots/sxm_details.png" height="500" alt="Details 6.">
    </td>
    <td align="center">
      <img src="screenshots/crew_details.png" height="500" alt="Details 7.">
    </td>
  </tr>
</table>

---

### Image galleries

<table align="center">
  <tr>
    <td align="center">
      <img src="screenshots/gallery_details_1.png" height="500" alt="Details 1.">
    </td>
    <td align="center">
      <img src="screenshots/gallery_details_2.png" height="500" alt="Details 2.">
    </td>
  </tr>
</table>

---

## 🛠️ Technical Stack & Architecture

This application is built with a focus on clean, scalable, and maintainable code, following modern best practices.

- **State Management:** `flutter_bloc` (using Cubit) for predictable and decoupled state management.
- **Architecture:** clean architecture separating presentation and data.
- **Data Modeling:** robust, type-safe models using `json_serializable` and `build_runner`.
- **Networking:** `http` package for making API calls to the [SpaceX API](https://github.com/r-spacex/SpaceX-API).
- **UI Design:** implements principles of Atomic Design for maximum widget reusability.
- **Local Storage:** `shared_preferences` for persisting user favorites and onboarding status.

## 🚀 Getting Started

To run this project locally, follow these steps:

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/maxbodin/spacex_app.git
    cd spacex_app
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Run the code generator:**
    (Required after any changes to model files)
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app:**
    ```sh
    flutter run
    ```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.