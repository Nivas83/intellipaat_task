import Foundation

public struct Lesson: Identifiable, Codable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let isCompleted: Bool

    public init(id: Int, title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }

    public func markedCompleted() -> Lesson {
        Lesson(id: id, title: title, isCompleted: true)
    }
}

public struct Course: Identifiable, Codable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let instructor: String
    public let lessons: [Lesson]

    public init(id: Int, title: String, instructor: String, lessons: [Lesson]) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.lessons = lessons
    }

    public var progress: Int {
        guard !lessons.isEmpty else { return 0 }
        return Int((Double(lessons.filter(\.isCompleted).count) / Double(lessons.count) * 100).rounded())
    }

    public var completedLessonCount: Int { lessons.filter(\.isCompleted).count }

    public func completingLesson(id lessonID: Int) -> Course {
        Course(id: id, title: title, instructor: instructor,
               lessons: lessons.map { $0.id == lessonID ? $0.markedCompleted() : $0 })
    }
}
