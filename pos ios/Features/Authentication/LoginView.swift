import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var startAnimation = false
    
    var body: some View {
        ZStack {
            animatedBackground
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    formSection
                    Spacer(minLength: 40)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            NavigationStack {
                StoreSelectionView()
            }
        }
    }
    
    private var animatedBackground: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "0x0B0C10"),
                    Color(hex: "0x1F2833"),
                    Color(hex: "0x0B0C10")
                ]),
                startPoint: startAnimation ? .topLeading : .bottomTrailing,
                endPoint: startAnimation ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: startAnimation)
            .onAppear {
                startAnimation.toggle()
            }
            
            Circle()
                .fill(Color(hex: "45A29E").opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 50)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(Color(hex: "66FCF1").opacity(0.1))
                .frame(width: 400, height: 400)
                .blur(radius: 60)
                .offset(x: 100, y: 300)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image("LoginMascot")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding(.top, 40)
                .padding(.bottom, 20)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
            
            VStack(spacing: 8) {
                Text("Hi, kamu balik lagi!")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Masukin data kamu buat lanjut, ya")
                    .font(.subheadline)
                    .foregroundColor(.primary.opacity(0.8))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 40)
        .offset(y: startAnimation ? 0 : 20)
        .opacity(startAnimation ? 1 : 0)
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2), value: startAnimation)
    }
    
    private var formSection: some View {
        VStack(spacing: 24) {
            CustomTextField(
                placeholder: "Username",
                text: $viewModel.username,
                label: "Username",
                keyboardType: .default,
                style: .glass
            )
            
            CustomTextField(
                placeholder: "Password",
                text: $viewModel.password,
                label: "Password",
                isSecure: true,
                style: .glass
            )
            
            HStack {
                Spacer()
                Button("Lupa Sandi?") {
                    if let url = URL(string: "https://webmail.erajaya.com/public/PasswordRecovery.jsp?") {
                        UIApplication.shared.open(url)
                    }
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary.opacity(0.8))
            }
            
            if !viewModel.errorMessage.isEmpty {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text(viewModel.errorMessage)
                        .font(.caption)
                        .foregroundColor(.orange)
                    Spacer()
                }
                .padding(.horizontal, 4)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
            
            CustomButton(
                title: "Sign In",
                action: { viewModel.login() },
                style: .primary,
                isDisabled: !viewModel.isValid,
                isLoading: viewModel.isLoading
            )
            .padding(.top, 12)
        }
        .padding(.horizontal, 28)
        .offset(y: startAnimation ? 0 : 30)
        .opacity(startAnimation ? 1 : 0)
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: startAnimation)
    }
}

#Preview {
    LoginView()
}
