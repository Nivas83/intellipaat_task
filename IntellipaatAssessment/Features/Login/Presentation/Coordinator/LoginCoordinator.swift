import SwiftUI

/// Builds the login feature with its feature-scoped dependencies.
final class LoginCoordinator: Coordinator {
    private let dependencies: any LoginCoordinatorDependencies

    init(dependencies: any LoginCoordinatorDependencies) { self.dependencies = dependencies }

    func makeView(onSuccess: @escaping () -> Void) -> LoginView {
        LoginView(viewModel: dependencies.makeViewModel(), onSuccess: onSuccess)
    }
}
