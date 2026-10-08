# Learning Dashboard

## Architecture
SwiftUI views render state owned by feature view models. `AppCoordinator` owns navigation and receives a `DIContainer`; the container composes use cases, repository, mock remote source, and local storage. `Domain` contains entities/contracts/use cases, `AppNetwork` supplies mock remote data, and `AppData` implements the repository and persistence.

## Offline support
Courses and lesson completion are stored with SwiftData. A successful fetch upserts mock data while preserving completed lessons. On a network failure, the repository returns saved courses if they exist. In Debug, **Simulate offline** demonstrates this fallback.

## Security
Production authentication tokens belong in the iOS Keychain with appropriate accessibility controls, never in `UserDefaults` or source code.

## Scale
Use a real paginated API, server-side progress synchronization/conflict resolution, authenticated refresh-token handling, background sync, observability/crash reporting, and image caching/CDN delivery.

## Android equivalent
Use Jetpack Compose, a Navigation coordinator, ViewModels and use cases, a repository with Retrofit/mock service, and Room for the same offline cache and completion workflow.
