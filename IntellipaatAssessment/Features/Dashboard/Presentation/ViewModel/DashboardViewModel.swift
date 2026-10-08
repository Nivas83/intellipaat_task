import Combine
import Domain

final class DashboardViewModel: ViewModel {
    @Published private(set) var state: DashboardViewState = .loading
    private let fetchCourses: any FetchCoursesUseCaseProtocol

    init(fetchCourses: any FetchCoursesUseCaseProtocol) { self.fetchCourses = fetchCourses }

    func load() {
        state = .loading
        Task {
            do {
                let courses = try await fetchCourses.execute()
                state = courses.isEmpty ? .empty : .content(courses)
            } catch CourseRepositoryError.network { state = .networkError }
            catch CourseRepositoryError.api(let message) { state = .apiError(message) }
            catch { state = .apiError("Something went wrong. Please try again.") }
        }
    }

    func replace(_ updatedCourse: Course) {
        guard case .content(let courses) = state else { return }
        state = .content(courses.map { $0.id == updatedCourse.id ? updatedCourse : $0 })
    }
}
