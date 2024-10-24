/*import Foundation
import SwiftUI
import CoreLocation

struct Notification: View {
    @StateObject private var locationManager = LocationManager() // Učitaj LocationManager
    @State private var isFireDepartmentSelected = true
    @State private var isHospitalSelected = false
    @State private var isPoliceStationSelected = false
    @State private var inputText: String = ""
    @State private var showConfirmationAlert = false
    @State private var showLoginAlert = false
    @State private var successMessage = ""

    // Učitavanje ID korisnika
    private var userId: Int {
        UserDefaults.standard.integer(forKey: "userId")
    }

    var body: some View {
        ZStack {
            Color(hex: "#EBE5F3")
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Zvonce na vrhu
                Image(systemName: "bell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .padding()

                Divider()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)

                // Opcije
                VStack(alignment: .leading, spacing: 15) {
                    OptionButton(title: "Vatrogasna stanica", isSelected: true) {
                    }

                    OptionButton(title: "Opšta bolnica Novi Pazar", isSelected: isHospitalSelected) {
                        isHospitalSelected.toggle()
                    }

                    OptionButton(title: "MUP Srbije", isSelected: isPoliceStationSelected) {
                        isPoliceStationSelected.toggle()
                    }
                }
                .padding(.horizontal, 30)
                
                Text("Unesite više informacija o situaciji požara:")
                    .foregroundColor(Color.black)
                    .padding(.top, 20)

                Divider()
                    .padding(.horizontal, 30)

                TextEditor(text: $inputText)
                    .frame(height: 150)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .padding(.horizontal, 30)
                    .padding(.top, 5)

                Button(action: {
                    
                    if userId == 0 {
                        print("User ID: \(userId)")
                        showLoginAlert = true // Prikazati upozorenje ako korisnik nije prijavljen
                    }else {
                        showConfirmationAlert = true
                    }
                }) {
                    Text("Pošalji")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(50)
                        .shadow(color: .gray, radius: 4, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                .alert(isPresented: $showLoginAlert) {
                    Alert(
                        title: Text("Prijava"),
                        message: Text("Morate da se prijavite da biste poslali obaveštenje."), dismissButton: .default(Text("U redu")))
                }
                .alert(isPresented: $showConfirmationAlert) {
                    Alert(
                        title: Text("Potvrda"),
                        message: Text("Da li ste sigurni da želite da pošaljete obaveštenje?"),
                        primaryButton: .destructive(Text("Da")) {
                            sendNotification()
                        },
                        secondaryButton: .cancel()
                    )
                }

                if !successMessage.isEmpty {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }

                Spacer()
            }
        }
    }

    private func sendNotification() {
        guard let url = URL(string: "http://alarmfire-001-site1.dtempurl.com/Notification/AddNotification") else {
            print("Invalid URL")
            return
        }

        let fireDepartment = isFireDepartmentSelected
        let hospital = isHospitalSelected
        let policeStation = isPoliceStationSelected

        let latitude = locationManager.location?.coordinate.latitude ?? 0.0
        let longitude = locationManager.location?.coordinate.longitude ?? 0.0

        let parameters: [String: Any] = [
            "fireDepartment": fireDepartment,
            "hospital": hospital,
            "policeStation": policeStation,
            "latitude": String(format: "%.6f", latitude),  // Konvertuj latitude u string
            "longitude": String(format: "%.6f", longitude),
            "description": inputText,
            "idUser": userId
        ]
        print(parameters)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Basic Auth
        let username = "11196448"
        let password = "60-dayfreetrial"
        let credentials = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error in JSON serialization: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.successMessage = "Error during notification: \(error.localizedDescription)"
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    self.successMessage = "Obaveštenje uspešno poslato!"
                    self.inputText = ""
                    self.isFireDepartmentSelected = true
                    self.isHospitalSelected = false
                    self.isPoliceStationSelected = false
                } else {
                    self.successMessage = "Greška prilikom slanja obaveštenja."
                }
            }
        }.resume()
    }
}

struct OptionButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(isSelected ? Color.red : Color.gray.opacity(0.3))
                    .frame(width: 20, height: 20)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
    }
}

#Preview {
    Notification()
}

*/

import Foundation
import SwiftUI
import CoreLocation

struct Notification: View {
    @StateObject private var locationManager = LocationManager() // Učitaj LocationManager
    @State private var isFireDepartmentSelected = true
    @State private var isHospitalSelected = false
    @State private var isPoliceStationSelected = false
    @State private var inputText: String = ""
    @State private var showConfirmationAlert = false
    @State private var successMessage = ""
    @State private var loginMessage: String? // Poruka za prijavu

    // Učitavanje ID korisnika
    private var userId: Int {
        UserDefaults.standard.integer(forKey: "userId")
    }

    var body: some View {
        ZStack {
            Color(hex: "#EBE5F3")
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Zvonce na vrhu
                Image(systemName: "bell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .padding()

                Divider()
                    .padding(.horizontal, 30)
                    .padding(.vertical, 10)

                // Opcije
                VStack(alignment: .leading, spacing: 15) {
                    OptionButton(title: "Vatrogasna stanica", isSelected: true) {
                    }

                    OptionButton(title: "Opšta bolnica Novi Pazar", isSelected: isHospitalSelected) {
                        isHospitalSelected.toggle()
                    }

                    OptionButton(title: "MUP Srbije", isSelected: isPoliceStationSelected) {
                        isPoliceStationSelected.toggle()
                    }
                }
                .padding(.horizontal, 30)
                
                Text("Unesite više informacija o situaciji požara:")
                    .foregroundColor(Color.black)
                    .padding(.top, 20)

                Divider()
                    .padding(.horizontal, 30)

                TextEditor(text: $inputText)
                    .frame(height: 150)
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                    .padding(.horizontal, 30)
                    .padding(.top, 5)

                Button(action: {
                    if userId == 0 {
                        // Postavi poruku kada korisnik nije prijavljen
                        loginMessage = "Morate da se prijavite da biste poslali obaveštenje."
                    } else {
                        loginMessage = nil // Ukloni poruku ako je korisnik prijavljen
                        showConfirmationAlert = true
                    }
                }) {
                    Text("Pošalji")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(50)
                        .shadow(color: .gray, radius: 4, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)

                .alert(isPresented: $showConfirmationAlert) {
                    Alert(
                        title: Text("Potvrda"),
                        message: Text("Da li ste sigurni da želite da pošaljete obaveštenje?"),
                        primaryButton: .destructive(Text("Da")) {
                            sendNotification()
                        },
                        secondaryButton: .cancel()
                    )
                }

                if let message = loginMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                if !successMessage.isEmpty {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }

                Spacer()
            }
        }
    }

    private func sendNotification() {
        guard let url = URL(string: "http://alarmfire-001-site1.dtempurl.com/Notification/AddNotification") else {
            print("Invalid URL")
            return
        }

        let fireDepartment = isFireDepartmentSelected
        let hospital = isHospitalSelected
        let policeStation = isPoliceStationSelected

        let latitude = locationManager.location?.coordinate.latitude ?? 0.0
        let longitude = locationManager.location?.coordinate.longitude ?? 0.0

        let parameters: [String: Any] = [
            "fireDepartment": fireDepartment,
            "hospital": hospital,
            "policeStation": policeStation,
            "latitude": String(format: "%.6f", latitude),  // Konvertuj latitude u string
            "longitude": String(format: "%.6f", longitude),
            "description": inputText,
            "idUser": userId
        ]
        print(parameters)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Basic Auth
        let username = "11196448"
        let password = "60-dayfreetrial"
        let credentials = "\(username):\(password)".data(using: .utf8)!.base64EncodedString()
        request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error in JSON serialization: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.successMessage = "Error during notification: \(error.localizedDescription)"
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    self.successMessage = "Obaveštenje uspešno poslato!"
                    self.inputText = ""
                    self.isFireDepartmentSelected = true
                    self.isHospitalSelected = false
                    self.isPoliceStationSelected = false
                } else {
                    self.successMessage = "Greška prilikom slanja obaveštenja."
                }
            }
        }.resume()
    }
}

struct OptionButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(isSelected ? Color.red : Color.gray.opacity(0.3))
                    .frame(width: 20, height: 20)

                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 2, x: 0, y: 0)
        }
    }
}

#Preview {
    Notification()
}

