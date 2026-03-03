import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    @State private var step1 = false 
    @State private var step2 = false 
    @State private var step3 = false
    
    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("savedStore") private var savedStoreData: Data = Data()
    
    var body: some View {
        if isActive {
            if !authToken.isEmpty, let store = try? JSONDecoder().decode(BusinessUnit.self, from: savedStoreData) {
                DashboardView(store: store)
            } else {
                LoginView()
            }
        } else {
            ZStack {
                (step2 ? Color.white : Color.black)
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.8), value: step2)
                
                VStack(spacing: 8) {
                    if !step3 {
                        // First Text: POINT OF SALES
                        Text("POINT OF SALES")
                            .font(.system(size: 32, weight: .heavy, design: .default))
                            .tracking(8) // Wide letter spacing
                            .foregroundColor(step2 ? .black : .white)
                            .scaleEffect(step1 ? 1.0 : 1.5)
                            .opacity(step1 ? 1.0 : 0.0)
                            .blur(radius: step1 ? 0 : 10)
                            .animation(.easeOut(duration: 1.2), value: step1)
                            .animation(.easeInOut(duration: 0.8), value: step2)
                    } else {
                        // Second Text: by TechDev POS
                        VStack(spacing: 4) {
                            Text("by")
                                .font(.system(size: 16, weight: .regular, design: .serif))
                                .italic()
                                .foregroundColor(.gray)
                            
                            Text("TechDev POS")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .tracking(4)
                                .foregroundColor(.black)
                        }
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale(scale: 0.9)),
                            removal: .opacity
                        ))
                    }
                }
            }
            .onAppear {
                startAnimationSequence()
            }
        }
    }
    
    private func startAnimationSequence() {
        withAnimation {
            step1 = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            step2 = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                step3 = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            withAnimation(.easeInOut(duration: 0.6)) {
                isActive = true
            }
        }
    }
}



#Preview {
    SplashScreenView()
}
