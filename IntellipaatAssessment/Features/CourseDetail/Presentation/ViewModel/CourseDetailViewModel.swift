import Combine
import Domain

final class CourseDetailViewModel: ViewModel {
    @Published private(set) var course: Course
    @Published private(set) var state: CourseDetailViewState
    private let completeLesson: any CompleteLessonUseCaseProtocol
    init(course: Course, completeLesson: any CompleteLessonUseCaseProtocol) {
        self.course = course
        self.state = .content(course)
        self.completeLesson = completeLesson
    }

    func complete(_ lesson: Lesson) {
        guard !lesson.isCompleted else { return }
        Task {
            do { course = try await completeLesson.execute(courseID: course.id, lessonID: lesson.id); state = .content(course) }
            catch { state = .error("Could not save your lesson progress.") }
        }
    }

    func dismissError() { state = .content(course) }
}
