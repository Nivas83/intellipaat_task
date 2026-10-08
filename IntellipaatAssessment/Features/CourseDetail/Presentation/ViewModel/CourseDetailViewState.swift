import Domain

enum CourseDetailViewState: ViewState {
    case content(Course)
    case error(String)
}
