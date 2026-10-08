import Domain
import Foundation
import SwiftData

public protocol CourseLocalStore: Sendable {
    func courses() throws -> [Course]
    func upsert(_ courses: [Course]) throws
    func markLessonComplete(courseID: Int, lessonID: Int) throws -> Course
}

public final class SwiftDataCourseStore: CourseLocalStore, @unchecked Sendable {
    private let context: ModelContext
    public init(context: ModelContext) { self.context = context }

    public func courses() throws -> [Course] {
        try context.fetch(FetchDescriptor<StoredCourse>())
            .sorted { $0.id < $1.id }
            .map(\.domain)
    }

    public func upsert(_ courses: [Course]) throws {
        let existing = try context.fetch(FetchDescriptor<StoredCourse>())
        for course in courses {
            if let record = existing.first(where: { $0.id == course.id }) {
                let completedIDs = Set(record.lessons.filter(\.isCompleted).map(\.id))
                record.title = course.title; record.instructor = course.instructor
                for lesson in record.lessons where !course.lessons.contains(where: { $0.id == lesson.id }) { context.delete(lesson) }
                for lesson in course.lessons {
                    if let stored = record.lessons.first(where: { $0.id == lesson.id }) {
                        stored.title = lesson.title; stored.isCompleted = stored.isCompleted || completedIDs.contains(lesson.id) || lesson.isCompleted
                    } else { record.lessons.append(StoredLesson(id: lesson.id, title: lesson.title, isCompleted: lesson.isCompleted)) }
                }
            } else {
                let record = StoredCourse(id: course.id, title: course.title, instructor: course.instructor)
                record.lessons = course.lessons.map { StoredLesson(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }
                context.insert(record)
            }
        }
        try context.save()
    }

    public func markLessonComplete(courseID: Int, lessonID: Int) throws -> Course {
        guard let course = try context.fetch(FetchDescriptor<StoredCourse>()).first(where: { $0.id == courseID }),
              let lesson = course.lessons.first(where: { $0.id == lessonID }) else {
            throw CourseRepositoryError.api(message: "Lesson could not be found.")
        }
        lesson.isCompleted = true; try context.save()
        return course.domain
    }
}

private extension StoredCourse {
    var domain: Course { Course(id: id, title: title, instructor: instructor, lessons: lessons.sorted { $0.id < $1.id }.map { Lesson(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }) }
}
