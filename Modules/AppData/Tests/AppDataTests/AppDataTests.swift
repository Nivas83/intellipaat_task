import AppData
import AppNetwork
import Domain
import SwiftData
import Testing

@Test func completionPersistsInSwiftData() async throws {
    let container = try ModelContainer(for: StoredCourse.self, StoredLesson.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let store = SwiftDataCourseStore(context: container.mainContext)
    let remote = MockCourseRemoteDataSource()
    let repository = CourseRepositoryImplementation(remote: remote, store: store)
    _ = try await repository.fetchCourses()
    let updated = try await repository.completeLesson(courseID: 1, lessonID: 103)
    #expect(updated.lessons.first(where: { $0.id == 103 })?.isCompleted == true)
    let storedCourse = try store.courses().first(where: { $0.id == 1 })
    #expect(storedCourse?.progress == 75)
}

@Test func networkFailureFallsBackToSavedCourses() async throws {
    let container = try ModelContainer(for: StoredCourse.self, StoredLesson.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let remote = MockCourseRemoteDataSource()
    let repository = CourseRepositoryImplementation(remote: remote, store: SwiftDataCourseStore(context: container.mainContext))
    let initiallyLoaded = try await repository.fetchCourses()
    await remote.setMode(.networkFailure)
    let cached = try await repository.fetchCourses()
    #expect(cached == initiallyLoaded)
}
