import Domain

/// Dependencies scoped to Course Detail and injected into CourseDetailCoordinator.
protocol CourseDetailCoordinatorDependencies {
    func makeViewModel(course: Course) -> CourseDetailViewModel
}

final class CourseDetailDIContainer: CourseDetailCoordinatorDependencies {
    private let completeLessonUseCase: any CompleteLessonUseCaseProtocol

    init(completeLessonUseCase: any CompleteLessonUseCaseProtocol) { self.completeLessonUseCase = completeLessonUseCase }

    func makeViewModel(course: Course) -> CourseDetailViewModel {
        CourseDetailViewModel(course: course, completeLesson: completeLessonUseCase)
    }
}
