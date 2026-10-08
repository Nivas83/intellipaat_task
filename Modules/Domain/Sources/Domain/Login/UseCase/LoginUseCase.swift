import Foundation

public protocol LoginUseCaseProtocol: Sendable {
    func execute(email: String, password: String) async throws
}

public struct LoginUseCase: LoginUseCaseProtocol, Sendable {
    private let repository: any AuthenticationRepository
    public init(repository: any AuthenticationRepository) { self.repository = repository }
    public func execute(email: String, password: String) async throws {
        try await repository.login(email: email, password: password)
    }
}
