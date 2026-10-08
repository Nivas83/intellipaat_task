import Domain

/// Dependencies scoped to the Login feature and injected into LoginCoordinator.
protocol LoginCoordinatorDependencies {
    func makeViewModel() -> LoginViewModel
}

final class LoginDIContainer: LoginCoordinatorDependencies {
    private let loginUseCase: any LoginUseCaseProtocol

    init(loginUseCase: any LoginUseCaseProtocol) { self.loginUseCase = loginUseCase }

    func makeViewModel() -> LoginViewModel { LoginViewModel(login: loginUseCase) }
}
