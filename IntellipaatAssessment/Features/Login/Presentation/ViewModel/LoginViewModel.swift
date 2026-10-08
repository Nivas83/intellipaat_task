import Combine
import Domain
import Foundation

final class LoginViewModel: ViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var state: LoginViewState = .idle
    private let login: any LoginUseCaseProtocol

    init(login: any LoginUseCaseProtocol) { self.login = login }

    func submit(onSuccess: @escaping () -> Void) {
        state = .idle
        guard email.range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"#, options: .regularExpression) != nil else {
            state = .error("Enter a valid email address."); return
        }
        guard !password.isEmpty else { state = .error("Enter your password."); return }
        state = .loading
        Task {
            do { try await login.execute(email: email, password: password); state = .success; onSuccess() }
            catch { state = .error("Login failed. Please try again.") }
        }
    }
}
