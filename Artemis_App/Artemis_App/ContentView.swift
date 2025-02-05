import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ChatbotView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chatbot")
                }

            ExploreView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Explore")
                }

            SafetyView()
                .tabItem {
                    Image(systemName: "shield.fill")
                    Text("Safety")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}
