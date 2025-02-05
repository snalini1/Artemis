import SwiftUI
import CoreLocation

struct EmergencyContact: Identifiable {
    let id: String
    let name: String
    let number: String
}

struct SafetyView: View {
    @State private var showAlert = false
    @State private var emergencyContacts: [EmergencyContact] = []
    @ObservedObject private var locationManager = UserLocationManager() // ✅ Renamed to avoid conflict

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Safety Center")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.blue)

                // Emergency Alert Banner
                if showAlert {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text("Emergency alert sent to your contacts!")
                            .foregroundColor(.red)
                        Spacer()
                        Button(action: { showAlert = false }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(10)
                }

                // Emergency Alert Button
                Button(action: handleEmergencyAlert) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Send Emergency Alert")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                }

                // Location Card
                VStack {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                        Text("Your current location: \(locationManager.userLocation ?? "Fetching...")")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                // Emergency Numbers Section
                Text("Local Emergency Numbers")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)

                VStack {
                    ForEach(emergencyContacts) { contact in
                        EmergencyContactRow(contact: contact)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                // View More Resources Button
                Button(action: {}) {
                    Text("View More Resources")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear(perform: fetchEmergencyContacts)
    }

    func handleEmergencyAlert() {
        showAlert = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showAlert = false
        }
    }

    func fetchEmergencyContacts() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.emergencyContacts = [
                EmergencyContact(id: "1", name: "Police", number: "911"),
                EmergencyContact(id: "2", name: "Ambulance", number: "911"),
                EmergencyContact(id: "3", name: "Fire Department", number: "911"),
                EmergencyContact(id: "4", name: "Poison Control", number: "1-800-222-1222")
            ]
        }
    }
}

// MARK: - Emergency Contact Row
struct EmergencyContactRow: View {
    let contact: EmergencyContact

    var body: some View {
        HStack {
            Text(contact.name)
                .foregroundColor(.primary)
            Spacer()
            Button(action: {
                callEmergencyNumber(number: contact.number)
            }) {
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.blue)
                    Text(contact.number)
                }
            }
        }
        .padding(.vertical, 5)
    }

    func callEmergencyNumber(number: String) {
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Custom Location Manager (Fixed Name)
class UserLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var userLocation: String?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.userLocation = "Lat: \(location.coordinate.latitude), Long: \(location.coordinate.longitude)"
        }
    }
}

