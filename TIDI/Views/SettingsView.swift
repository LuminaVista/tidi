import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var appViewModel: AppViewModel
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(hex: "#DDD4C8").ignoresSafeArea()

                VStack(spacing: 0) {
                    // Logo
                    VStack {
                        HStack {
                            Spacer()
                            Image("app_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 10)

                    // White Box Content
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Account Deletion")
                            .font(.headline)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)

                        VStack(alignment: .leading, spacing: 15) {
                            Text("Once you delete your account:")
                                .bold()
                            deletionBullet("Your account with all of its details will be deleted permanently")
                            deletionBullet("All the business ideas (active + inactive) will be deleted permanently")
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)

                        VStack {
                            Text("Please Re-type your email to delete your account permanently")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)

                        CustomTextField(placeholder: "Re-type your email", text: $viewModel.retypedEmail)

                        // Delete Button
                        Button(action: {
                            viewModel.deleteAccount()
                        }) {
                            Text("Delete My Account")
                                .foregroundColor(viewModel.retypedEmail.isEmpty ? .gray : .black)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#DDD4C8"))
                                .cornerRadius(12)
                        }
                        .disabled(viewModel.retypedEmail.isEmpty)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if viewModel.appViewModel == nil {
                viewModel.appViewModel = appViewModel
            }
        }
    }

    func deletionBullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
                .font(.system(size: 15))
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppViewModel())
}
