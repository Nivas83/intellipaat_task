import Foundation

public enum CourseRepositoryError: Error, Equatable, Sendable {
    case network
    case api(message: String)
}

public protocol CourseRepository: Sendable {
    func fetchCourses() async throws -> [Course]
    func completeLesson(courseID: Int, lessonID: Int) async throws -> Course
}
