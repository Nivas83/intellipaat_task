import Foundation

public protocol AuthenticationRepository: Sendable {
    func login(email: String, password: String) async throws
}
