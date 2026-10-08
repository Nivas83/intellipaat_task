import AppNetwork
import Domain
import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    enum Route: Hashable { case course(Course) }

    @Published var isAuthenticated = false
    @Published var path = NavigationPath()
    @Published var isOfflineSimulationEnabled = false
    let container: DIContainer
    let loginDIContainer: LoginDIContainer
    let dashboardCoordinator: DashboardCoordinator
    let courseDetailDIContainer: CourseDetailDIContainer

    init(container: DIContainer) {
        self.container = container
        self.loginDIContainer = container.makeLoginDIContainer()
        self.dashboardCoordinator = DashboardCoordinator(dependencies: container.makeDashboardDIContainer())
        self.courseDetailDIContainer = container.makeCourseDetailDIContainer()
    }

    func loginSucceeded() { isAuthenticated = true }
    func showCourse(_ course: Course) { path.append(Route.course(course)) }

    func setOfflineSimulation(_ enabled: Bool) {
        isOfflineSimulationEnabled = enabled
        Task { await container.remoteDataSource.setMode(enabled ? .networkFailure : .success) }
    }
}

struct AppCoordinatorView: View {
    @StateObject private var coordinator: AppCoordinator

    init(container: DIContainer) { _coordinator = StateObject(wrappedValue: AppCoordinator(container: container)) }

    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                NavigationStack(path: $coordinator.path) {
                    coordinator.dashboardCoordinator.makeView(
                        offlineSimulationEnabled: $coordinator.isOfflineSimulationEnabled,
                        setOfflineSimulation: coordinator.setOfflineSimulation,
                        showCourse: coordinator.showCourse
                    )
                    .navigationDestination(for: AppCoordinator.Route.self) { route in
                        switch route {
                        case .course(let course):
                            CourseDetailCoordinator(
                                dependencies: coordinator.courseDetailDIContainer,
                                course: course,
                                onCourseUpdated: coordinator.dashboardCoordinator.update
                            ).makeView()
                        }
                    }
                }
            } else {
                LoginCoordinator(dependencies: coordinator.loginDIContainer)
                    .makeView(onSuccess: coordinator.loginSucceeded)
            }
        }
    }
}
