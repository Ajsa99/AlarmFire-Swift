import SwiftUI

struct Information: View {
    var body: some View {
        ZStack {
            Color(hex: "#EBE5F3")
                .edgesIgnoringSafeArea(.all)

            ScrollView{
                VStack {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 70, maxHeight: 70)
                        .clipped()
                    
                    Text("Informacije")
                        .font(.title2)
                        .padding(.bottom, 20)
                    
                    Divider()
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                    
                    Image("info1")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipped()
                    
                    
                    Text("Ova aplikacija je ključna za brzo obaveštavanje o požarima i omogućava korisnicima da brzo reagiraju. Uključuje funkcionalnosti kao što su:")
                        .font(.body)
                        .padding(.vertical)
                    
                    VStack(alignment: .leading) {
                        Text("• Brza obaveštenja")
                        Text("• Geolokacija za precizno praćenje")
                        Text("• Uputstva za evakuaciju")
                        Text("• Povezivanje sa lokalnim službama")
                    }
                    
                    Text("Kako se koristi?")
                        .font(.headline)
                        .padding()
                    
                    Text("Jednostavno je! Samo preuzmite aplikaciju, kreirajte nalog i omogućite geolokaciju.")
                        .font(.body)
                        .padding(.bottom)
                   
                    Text("Kada primite upozorenje, pratite uputstva na ekranu i obavezite se da ćete se pridržavati svih preporuka.")
                        .font(.body)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    Information()
}
