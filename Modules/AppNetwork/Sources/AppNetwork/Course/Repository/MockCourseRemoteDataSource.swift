import Domain
import Foundation

public enum RemoteResultMode: Sendable {
    case success
    case empty
    case networkFailure
    case apiFailure
}

public protocol CourseRemoteDataSource: Sendable {
    func fetchCourses() async throws -> [Course]
}

public actor MockCourseRemoteDataSource: CourseRemoteDataSource {
    private var mode: RemoteResultMode

    public init(mode: RemoteResultMode = .success) { self.mode = mode }
    public func setMode(_ mode: RemoteResultMode) { self.mode = mode }

    public func fetchCourses() async throws -> [Course] {
        try await Task.sleep(for: .milliseconds(450))
        switch mode {
        case .success: return Self.sampleCourses
        case .empty: return []
        case .networkFailure: throw CourseRepositoryError.network
        case .apiFailure: throw CourseRepositoryError.api(message: "We could not load courses. Please try again.")
        }
    }

    public static let sampleCourses: [Course] = [
        Course(id: 1, title: "Python Programming", instructor: "John Smith", lessons: [
            Lesson(id: 101, title: "Introduction", isCompleted: true), Lesson(id: 102, title: "Variables & Data Types", isCompleted: true), Lesson(id: 103, title: "Functions"), Lesson(id: 104, title: "OOP")
        ]),
        Course(id: 2, title: "Generative AI", instructor: "Sarah Williams", lessons: [
            Lesson(id: 201, title: "Introduction to AI", isCompleted: true), Lesson(id: 202, title: "Prompt Engineering"), Lesson(id: 203, title: "LLM Applications"), Lesson(id: 204, title: "Responsible AI"), Lesson(id: 205, title: "Capstone")
        ]),
        Course(id: 3, title: "Full Stack Development", instructor: "David Brown", lessons: [
            Lesson(id: 301, title: "Web Foundations"), Lesson(id: 302, title: "Frontend Development"), Lesson(id: 303, title: "Backend APIs"), Lesson(id: 304, title: "Databases")
        ])
    ]
}
