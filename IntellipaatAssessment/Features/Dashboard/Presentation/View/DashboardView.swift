import Domain
import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    @Binding var isOfflineSimulationEnabled: Bool
    let setOfflineSimulation: (Bool) -> Void
    let showCourse: (Course) -> Void

    var body: some View {
        Group {
            switch viewModel.state {
            case .loading: ProgressView("Loading your courses…").frame(maxWidth: .infinity, maxHeight: .infinity)
            case .content(let courses): courseList(courses)
            case .empty: StateView(icon: "tray", title: "No courses yet", detail: "Your enrolled courses will appear here.", retry: viewModel.load)
            case .networkError: StateView(icon: "wifi.slash", title: "You’re offline", detail: "Connect to the internet, then try again.", retry: viewModel.load)
            case .apiError(let message): StateView(icon: "exclamationmark.triangle", title: "Couldn’t load courses", detail: message, retry: viewModel.load)
            }
        }
        .navigationTitle("My Learning")
        .task { viewModel.load() }
    }

    private func courseList(_ courses: [Course]) -> some View {
        List {
            #if DEBUG
            Section {
                Toggle("Simulate offline", isOn: Binding(get: { isOfflineSimulationEnabled }, set: setOfflineSimulation))
            } footer: { Text("Uses previously saved SwiftData courses when enabled.") }
            #endif
            Section {
                ForEach(courses) { course in
                    Button { showCourse(course) } label: { CourseCard(course: course) }.buttonStyle(.plain)
                }
            }
        }.refreshable { viewModel.load() }
    }
}

private struct CourseCard: View {
    let course: Course
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(course.title).font(.headline).foregroundStyle(.primary)
            Text(course.instructor).font(.subheadline).foregroundStyle(.secondary)
            ProgressView(value: Double(course.progress), total: 100).tint(.indigo)
            HStack { Text("\(course.progress)% complete"); Spacer(); Text("\(course.lessons.count) lessons") }.font(.caption).foregroundStyle(.secondary)
            Text("Continue").font(.subheadline.bold()).foregroundStyle(.indigo)
        }.padding(.vertical, 6)
    }
}

struct StateView: View {
    let icon: String; let title: String; let detail: String; let retry: () -> Void
    var body: some View {
        ContentUnavailableView { Label(title, systemImage: icon) } description: { Text(detail) } actions: { Button("Try Again", action: retry).buttonStyle(.bordered) }
    }
}
