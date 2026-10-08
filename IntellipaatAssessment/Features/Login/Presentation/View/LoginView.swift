import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    let onSuccess: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "graduationcap.fill").font(.system(size: 54)).foregroundStyle(.indigo)
            Text("Learning Dashboard").font(.largeTitle.bold())
            Text("Continue your learning journey").foregroundStyle(.secondary)
            VStack(spacing: 12) {
                TextField("Email", text: $viewModel.email).textInputAutocapitalization(.never).keyboardType(.emailAddress).textContentType(.emailAddress).padding().background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                SecureField("Password", text: $viewModel.password).textContentType(.password).padding().background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
            }
            if case .error(let error) = viewModel.state { Text(error).font(.footnote).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading) }
            Button { viewModel.submit(onSuccess: onSuccess) } label: {
                Group { if case .loading = viewModel.state { ProgressView().tint(.white) } else { Text("Login").bold() } }.frame(maxWidth: .infinity).padding()
            }.buttonStyle(.borderedProminent).disabled(viewModel.state == .loading)
            Spacer()
        }.padding(24)
    }
}
