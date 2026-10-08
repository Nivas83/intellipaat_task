import AppData
import AppNetwork
import Domain
import SwiftData

final class DIContainer {
    // App composition root. It creates feature-scoped containers; coordinators
    // receive only the dependencies of their own feature.
    let remoteDataSource: MockCourseRemoteDataSource
    private let courseRepository: CourseRepositoryImplementation
    private let authenticationRepository = MockAuthenticationRepository()

    init(modelContext: ModelContext) {
        let remote = MockCourseRemoteDataSource()
        self.remoteDataSource = remote
        self.courseRepository = CourseRepositoryImplementation(
            remote: remote,
            store: SwiftDataCourseStore(context: modelContext)
        )
    }

    func makeLoginDIContainer() -> LoginDIContainer {
        LoginDIContainer(loginUseCase: LoginUseCase(repository: authenticationRepository))
    }

    func makeDashboardDIContainer() -> DashboardDIContainer {
        DashboardDIContainer(fetchCoursesUseCase: FetchCoursesUseCase(repository: courseRepository))
    }

    func makeCourseDetailDIContainer() -> CourseDetailDIContainer {
        CourseDetailDIContainer(completeLessonUseCase: CompleteLessonUseCase(repository: courseRepository))
    }
}
