import Domain
import SwiftUI

struct CourseDetailView: View {
    @StateObject var viewModel: CourseDetailViewModel
    let onCourseUpdated: (Domain.Course) -> Void
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.course.instructor).foregroundStyle(.secondary)
                    ProgressView(value: Double(viewModel.course.progress), total: 100).tint(.indigo)
                    Text("\(viewModel.course.progress)% complete · \(viewModel.course.completedLessonCount) of \(viewModel.course.lessons.count) lessons").font(.subheadline).foregroundStyle(.secondary)
                }.padding(.vertical, 4)
            }
            Section("Lessons") {
                ForEach(viewModel.course.lessons) { lesson in
                    Button { viewModel.complete(lesson) } label: {
                        HStack { Image(systemName: lesson.isCompleted ? "checkmark.circle.fill" : "circle").foregroundStyle(lesson.isCompleted ? .green : .secondary); Text(lesson.title).foregroundStyle(.primary); Spacer(); if !lesson.isCompleted { Text("Mark complete").font(.caption).foregroundStyle(.indigo) } }
                    }.buttonStyle(.plain).disabled(lesson.isCompleted)
                }
            }
        }.navigationTitle(viewModel.course.title)
            .onChange(of: viewModel.course) { _, course in onCourseUpdated(course) }
            .alert("Unable to save", isPresented: Binding(get: { if case .error = viewModel.state { return true }; return false }, set: { if !$0 { viewModel.dismissError() } })) { Button("OK", role: .cancel) {} } message: { if case .error(let message) = viewModel.state { Text(message) } else { EmptyView() } }
    }
}
