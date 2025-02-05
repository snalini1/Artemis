import SwiftUI

struct BucketListItem: Identifiable {
    let id: String
    let name: String
    var visited: Bool
    let coordinates: (latitude: Double, longitude: Double)
}

struct ProfileView: View {
    @State private var bucketList: [BucketListItem] = [
        BucketListItem(id: "1", name: "Paris", visited: true, coordinates: (48.8566, 2.3522)),
        BucketListItem(id: "2", name: "Tokyo", visited: false, coordinates: (35.6762, 139.6503)),
        BucketListItem(id: "3", name: "New York", visited: true, coordinates: (40.7128, -74.0060)),
        BucketListItem(id: "4", name: "Rome", visited: false, coordinates: (41.9028, 12.4964))
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Profile Header
                HStack(spacing: 16) {
                    Image("profile_placeholder") // Add to Assets.xcassets
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text("Jane Doe")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)

                        Text("@jane_traveler")
                            .foregroundColor(.gray)
                    }
                }

                // Bio
                Text("Adventure seeker, coffee lover, and solo traveler. Always looking for the next exciting destination!")
                    .foregroundColor(.gray)

                // Buttons
                HStack {
                    Button(action: {}) {
                        Text("Edit Profile")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.blue)
                            .cornerRadius(8)
                    }
                    Button(action: {}) {
                        Text("Follow")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                // Bucket List Section
                Text("Travel Bucket List")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)

                WorldMapView(bucketList: $bucketList) // Custom map view

                // Bucket List Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(bucketList) { item in
                        BucketListCard(item: item, toggleVisited: toggleVisited)
                    }
                }
                .padding(.top)

                // Recent Posts Section
                Text("Recent Posts")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)

                RecentPost(text: "Just arrived in Paris! Can't wait to explore the city of lights. #ArtemisTravel #Paris")
                RecentPost(text: "Safety tip: Always share your location with a trusted friend when traveling solo. #TravelSafety")
            }
            .padding()
        }
    }

    func toggleVisited(id: String) {
        if let index = bucketList.firstIndex(where: { $0.id == id }) {
            bucketList[index].visited.toggle()
        }
    }
}

// MARK: - World Map Placeholder
struct WorldMapView: View {
    @Binding var bucketList: [BucketListItem]

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
                .cornerRadius(12)

            Text("World Map Placeholder")
                .foregroundColor(.gray)

            ForEach(bucketList) { item in
                Circle()
                    .fill(item.visited ? Color.blue : Color.gray)
                    .frame(width: 10, height: 10)
                    .position(
                        x: CGFloat(((item.coordinates.longitude + 180) / 360) * 300),
                        y: CGFloat(((90 - item.coordinates.latitude) / 180) * 150)
                    )
            }
        }
    }
}

// MARK: - Bucket List Card
struct BucketListCard: View {
    let item: BucketListItem
    let toggleVisited: (String) -> Void

    var body: some View {
        Button(action: { toggleVisited(item.id) }) {
            HStack {
                Text(item.name)
                    .foregroundColor(item.visited ? .blue : .gray)

                Spacer()
                if item.visited {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

// MARK: - Recent Posts Card
struct RecentPost: View {
    let text: String

    var body: some View {
        Text(text)
            .foregroundColor(.gray)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

