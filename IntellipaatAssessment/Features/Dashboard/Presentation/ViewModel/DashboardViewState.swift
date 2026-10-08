import Domain

enum DashboardViewState: ViewState {
    case loading
    case content([Course])
    case empty
    case networkError
    case apiError(String)
}
