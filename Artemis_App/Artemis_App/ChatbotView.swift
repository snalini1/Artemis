import SwiftUI
import Speech
import CoreLocation

import SwiftUI

struct Message: Identifiable {
    let id: Int
    let text: String
    let isUser: Bool
}

struct ChatbotView: View {
    @State private var messages: [Message] = [
        Message(id: 1, text: "Hi there! I'm Artemis AI, your travel assistant. How can I help you today?", isUser: false)
    ]
    @State private var inputText: String = ""
    @State private var isRecording = false
    @ObservedObject private var speechRecognizer = SpeechRecognizer()
    @ObservedObject private var locationManager = LocationManager()

    var body: some View {
        VStack {
            Text("Artemis AI")
                .font(.title)
                .bold()
                .foregroundColor(.blue)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isUser { Spacer() }
                            Text(message.text)
                                .padding()
                                .background(message.isUser ? Color.blue.opacity(0.8) : Color.gray.opacity(0.8))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .frame(maxWidth: 250, alignment: message.isUser ? .trailing : .leading)
                            if !message.isUser { Spacer() }
                        }
                    }
                }
            }
            .padding()
            
            // Quick Action Buttons
            HStack {
                Button(action: { handleQuickAction("location") }) {
                    Label("Share Location", systemImage: "location.fill")
                }
                .buttonStyle(.borderedProminent)

                Button(action: { handleQuickAction("emergency") }) {
                    Label("Emergency Help", systemImage: "exclamationmark.triangle.fill")
                }
                .buttonStyle(.borderedProminent)

                Button(action: { handleQuickAction("itinerary") }) {
                    Label("Plan Itinerary", systemImage: "calendar")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.bottom, 5)

            // Text Input and Voice Input
            HStack {
                TextField("Type your message...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: handleSend) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }

                Button(action: handleRecord) {
                    Image(systemName: isRecording ? "mic.fill" : "mic")
                        .foregroundColor(.white)
                        .padding()
                        .background(isRecording ? Color.red : Color.gray)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
    }

    func handleSend() {
        if !inputText.trimmingCharacters(in: .whitespaces).isEmpty {
            let newMessage = Message(id: messages.count + 1, text: inputText, isUser: true)
            messages.append(newMessage)
            inputText = ""

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                simulateResponse(for: newMessage.text)
            }
        }
    }

    func handleRecord() {
        isRecording.toggle()
        if isRecording {
            speechRecognizer.startRecording { result in
                self.inputText = result
                self.isRecording = false
            }
        } else {
            speechRecognizer.stopRecording()
        }
    }

    func handleQuickAction(_ action: String) {
        let actionMessage: String
        switch action {
        case "location":
            if let location = locationManager.currentLocation {
                actionMessage = "Sharing my location: \(location.latitude), \(location.longitude)"
            } else {
                actionMessage = "Fetching location..."
            }
        case "emergency":
            actionMessage = "I need emergency assistance!"
        case "itinerary":
            actionMessage = "Can you help me plan my itinerary?"
        default:
            actionMessage = "Action not recognized."
        }

        let newMessage = Message(id: messages.count + 1, text: actionMessage, isUser: true)
        messages.append(newMessage)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            simulateResponse(for: actionMessage)
        }
    }

    func simulateResponse(for userInput: String) {
        let response: String
        if userInput.lowercased().contains("itinerary") {
            response = "Sure! Where are you planning to visit, and for how long?"
        } else if userInput.lowercased().contains("safe word") {
            response = "Great idea! What word would you like to use?"
        } else if userInput.lowercased().contains("emergency") {
            response = "Would you like me to contact local authorities or notify your emergency contacts?"
        } else if userInput.lowercased().contains("fun ideas") {
            response = "You could explore museums, local restaurants, or take a guided tour. What interests you?"
        } else {
            response = "I'm here to assist with travel plans and safety. How can I help?"
        }

        let botMessage = Message(id: messages.count + 1, text: response, isUser: false)
        messages.append(botMessage)
    }
}

// MARK: - Speech Recognition
class SpeechRecognizer: NSObject, ObservableObject, SFSpeechRecognizerDelegate {
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    func startRecording(completion: @escaping (String) -> Void) {
        let request = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                completion(result.bestTranscription.formattedString)
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            request.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionTask?.cancel()
    }
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
}
