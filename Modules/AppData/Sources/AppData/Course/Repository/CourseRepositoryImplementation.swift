import AppNetwork
import Domain

public final class CourseRepositoryImplementation: CourseRepository, @unchecked Sendable {
    private let remote: any CourseRemoteDataSource
    private let store: any CourseLocalStore

    public init(remote: any CourseRemoteDataSource, store: any CourseLocalStore) { self.remote = remote; self.store = store }

    public func fetchCourses() async throws -> [Course] {
        do {
            let courses = try await remote.fetchCourses()
            try await MainActor.run { try store.upsert(courses) }
            return try await MainActor.run { try store.courses() }
        } catch let error as CourseRepositoryError where error == .network {
            let cached = try await MainActor.run { try store.courses() }
            guard !cached.isEmpty else { throw error }
            return cached
        } catch { throw error }
    }

    public func completeLesson(courseID: Int, lessonID: Int) async throws -> Course {
        try await MainActor.run { try store.markLessonComplete(courseID: courseID, lessonID: lessonID) }
    }
}
