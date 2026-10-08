import Domain

/// Dependencies scoped to the Dashboard feature and injected into DashboardCoordinator.
protocol DashboardCoordinatorDependencies {
    func makeViewModel() -> DashboardViewModel
}

final class DashboardDIContainer: DashboardCoordinatorDependencies {
    private let fetchCoursesUseCase: any FetchCoursesUseCaseProtocol

    init(fetchCoursesUseCase: any FetchCoursesUseCaseProtocol) { self.fetchCoursesUseCase = fetchCoursesUseCase }

    func makeViewModel() -> DashboardViewModel { DashboardViewModel(fetchCourses: fetchCoursesUseCase) }
}
