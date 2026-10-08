import Domain
import SwiftUI

/// Builds the dashboard feature and forwards navigation to the root coordinator.
final class DashboardCoordinator: Coordinator {
    private let dependencies: any DashboardCoordinatorDependencies
    private let viewModel: DashboardViewModel

    init(dependencies: any DashboardCoordinatorDependencies) {
        self.dependencies = dependencies
        self.viewModel = dependencies.makeViewModel()
    }

    func makeView(offlineSimulationEnabled: Binding<Bool>, setOfflineSimulation: @escaping (Bool) -> Void, showCourse: @escaping (Course) -> Void) -> DashboardView {
        DashboardView(viewModel: self.viewModel, isOfflineSimulationEnabled: offlineSimulationEnabled, setOfflineSimulation: setOfflineSimulation, showCourse: showCourse)
    }

    func update(_ course: Course) { viewModel.replace(course) }
}
