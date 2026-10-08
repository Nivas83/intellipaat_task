import Domain
import Foundation

public struct MockAuthenticationRepository: AuthenticationRepository, Sendable {
    public init() {}

    public func login(email: String, password: String) async throws {
        try await Task.sleep(for: .milliseconds(350))
    }
}
