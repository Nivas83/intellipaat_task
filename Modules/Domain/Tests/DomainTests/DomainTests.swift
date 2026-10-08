import Testing
@testable import Domain

@Test func completingALessonRecalculatesProgress() {
    let course = Course(id: 1, title: "Swift", instructor: "Ada", lessons: [
        Lesson(id: 1, title: "Introduction"), Lesson(id: 2, title: "Functions")
    ])
    let updated = course.completingLesson(id: 1)
    #expect(updated.lessons[0].isCompleted)
    #expect(updated.progress == 50)
}
