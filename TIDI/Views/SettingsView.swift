import SwiftUI

struct SettingsView: View {
    
    @State private var retypedEmail: String = ""
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    // White Content
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Account Deletion")
                            .font(.headline)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Deletion Warnings
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Once you delete your account:")
                                .bold()
                            deletionBullet("Your account with all of its details will be deleted permanently")
                            deletionBullet("All the business ideas (active + inactive) will be deleted permanently")
                            deletionBullet("All the AI-generated feedback will be permanently deleted")
                            deletionBullet("All the AI-generated and user-generated tasks will be permanently deleted")
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                        
                        
                        VStack{
                            Text("Please Re-type your email to delete your account permanently")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        CustomTextField(placeholder: "Re-type your email", text: $retypedEmail)
                        
                        
                        // Delete Button
                        Button(action: {
                            // Simulate delete + back to registration
                            //presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Delete My Account")
                                .foregroundColor(retypedEmail.isEmpty ? .gray : .black)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#DDD4C8"))
                                .cornerRadius(12)
                        }
                        .disabled(retypedEmail.isEmpty)
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
    }
    
    // MARK: - Reusable Bullet View
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
}
