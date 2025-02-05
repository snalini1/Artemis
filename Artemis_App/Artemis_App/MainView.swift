import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .chatbot

    var body: some View {
        NavigationStack { // ✅ Replaced NavigationView with NavigationStack for better control
            ZStack {
                RoundedRectangle(cornerRadius: 60)
                    .fill(Color.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 60)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 14)
                    )
                    .shadow(radius: 10)
                    .ignoresSafeArea()

                VStack {
                    // Header
                    HStack {
                        Text("Artemis")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.purple)

                        Spacer()

                        // ✅ Working Profile Button
                        Button(action: {
                            selectedTab = .profile
                        }) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.purple)
                                )
                        }
                    }
                    .padding()

                    // Main Content (Dynamic View)
                    ZStack {
                        if selectedTab == .chatbot {
                            ChatbotView()
                        } else if selectedTab == .explore {
                            ExploreView()
                        } else if selectedTab == .safety {
                            SafetyView()
                        } else if selectedTab == .profile {
                            ProfileView()
                        }
                    }
                    .frame(maxHeight: .infinity)

                    // Bottom Navigation Bar
                    HStack {
                        TabBarItem(selectedTab: $selectedTab, tab: .chatbot, icon: "heart.fill", label: "Artemis AI")
                        TabBarItem(selectedTab: $selectedTab, tab: .explore, icon: "safari.fill", label: "Explore")
                        TabBarItem(selectedTab: $selectedTab, tab: .safety, icon: "shield.fill", label: "Safety")
                        TabBarItem(selectedTab: $selectedTab, tab: .profile, icon: "person.fill", label: "Profile") // ✅ Profile tab
                    }
                    .padding()
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                }
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// MARK: - Bottom Tab Enum
enum Tab {
    case chatbot, explore, safety, profile
}

// MARK: - Tab Bar Item Component
struct TabBarItem: View {
    @Binding var selectedTab: Tab
    let tab: Tab
    let icon: String
    let label: String

    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(selectedTab == tab ? .blue : .purple)

                Text(label)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .blue : .purple)
            }
            .padding()
            .background(selectedTab == tab ? Color.purple.opacity(0.2) : Color.clear)
            .cornerRadius(10)
            .scaleEffect(selectedTab == tab ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedTab)
        }
    }
}
