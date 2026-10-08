import AppData
import SwiftData
import SwiftUI

@main struct MyApp: App {
    private let modelContainer: ModelContainer
    private let container: DIContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: StoredCourse.self, StoredLesson.self)
            container = DIContainer(modelContext: modelContainer.mainContext)
        } catch {
            fatalError("Unable to create the local course store: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(container: container)
                .modelContainer(modelContainer)
        }
    }
}
