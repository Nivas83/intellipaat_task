enum LoginViewState: ViewState {
    case idle
    case loading
    case error(String)
    case success
}
