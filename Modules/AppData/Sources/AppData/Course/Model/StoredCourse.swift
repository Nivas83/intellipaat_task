import SwiftData

@Model public final class StoredCourse {
    @Attribute(.unique) public var id: Int
    public var title: String
    public var instructor: String
    @Relationship(deleteRule: .cascade, inverse: \StoredLesson.course) public var lessons: [StoredLesson]

    public init(id: Int, title: String, instructor: String, lessons: [StoredLesson] = []) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.lessons = lessons
    }
}

@Model public final class StoredLesson {
    @Attribute(.unique) public var id: Int
    public var title: String
    public var isCompleted: Bool
    public var course: StoredCourse?

    public init(id: Int, title: String, isCompleted: Bool, course: StoredCourse? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.course = course
    }
}
