import Combine

/// Marker adopted by feature-specific, immutable screen states.
protocol ViewState: Equatable {}

/// Shared presentation contract implemented by every feature view model.
protocol ViewModel: AnyObject, ObservableObject {
    associatedtype State: ViewState
    var state: State { get }
}
