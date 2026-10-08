import Foundation

public protocol FetchCoursesUseCaseProtocol: Sendable {
    func execute() async throws -> [Course]
}

public struct FetchCoursesUseCase: FetchCoursesUseCaseProtocol, Sendable {
    private let repository: any CourseRepository
    public init(repository: any CourseRepository) { self.repository = repository }
    public func execute() async throws -> [Course] { try await repository.fetchCourses() }
}

public protocol CompleteLessonUseCaseProtocol: Sendable {
    func execute(courseID: Int, lessonID: Int) async throws -> Course
}

public struct CompleteLessonUseCase: CompleteLessonUseCaseProtocol, Sendable {
    private let repository: any CourseRepository
    public init(repository: any CourseRepository) { self.repository = repository }
    public func execute(courseID: Int, lessonID: Int) async throws -> Course {
        try await repository.completeLesson(courseID: courseID, lessonID: lessonID)
    }
}
