import Domain
import SwiftUI

/// Builds a selected-course detail feature and propagates saved changes upward.
final class CourseDetailCoordinator: Coordinator {
    private let dependencies: any CourseDetailCoordinatorDependencies
    private let course: Course
    private let onCourseUpdated: (Course) -> Void

    init(dependencies: any CourseDetailCoordinatorDependencies, course: Course, onCourseUpdated: @escaping (Course) -> Void) {
        self.dependencies = dependencies
        self.course = course
        self.onCourseUpdated = onCourseUpdated
    }

    func makeView() -> CourseDetailView {
        CourseDetailView(viewModel: self.dependencies.makeViewModel(course: self.course), onCourseUpdated: onCourseUpdated)
    }
}
