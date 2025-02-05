import SwiftUI

struct Destination: Identifiable {
    let id: String
    let name: String
    let image: String
}

struct ExploreView: View {
    @State private var searchTerm: String = ""
    
    private let destinations: [Destination] = [
        Destination(id: "1", name: "Paris", image: "paris"),
        Destination(id: "2", name: "Tokyo", image: "tokyo"),
        Destination(id: "3", name: "New York", image: "newyork"),
        Destination(id: "4", name: "Rome", image: "rome"),
        Destination(id: "5", name: "Sydney", image: "sydney"),
        Destination(id: "6", name: "Barcelona", image: "barcelona")
    ]

    var filteredDestinations: [Destination] {
        if searchTerm.isEmpty {
            return destinations
        } else {
            return destinations.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Explore")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top)

                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.blue)
                    TextField("Search cities and places", text: $searchTerm)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                }
                .padding(.horizontal)
                
                Text("Popular Destinations")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                    .padding(.top)

                // Grid of Destinations
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredDestinations) { destination in
                            DestinationCard(destination: destination)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct DestinationCard: View {
    let destination: Destination

    var body: some View {
        VStack {
            Image(destination.image)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 100)
                .clipped()
                .cornerRadius(10)
            
            Text(destination.name)
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding(8)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
        .shadow(radius: 5)
    }
}
