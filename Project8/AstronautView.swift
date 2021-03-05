//
//  AstronautView.swift
//  Project8
//
//  Created by Jacob LeCoq on 2/22/21.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Int]

    init(astronaut: Astronaut) {
        self.astronaut = astronaut

        let missions: [Mission] = Bundle.main.decode("missions.json")

        var matches = [Int]()

        for mission in missions {
            for crew in mission.crew {
                if astronaut.id == crew.name {
                    matches.append(mission.id)
                }
            }
        }

        self.missions = matches
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)

                    Text("Missions participated")
                        .font(.headline)
                    ForEach(self.missions, id: \.self) { mission in
                        VStack {
                            Text("Apollo \(mission)")
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")

    static var previews: some View {
        NavigationView {
            AstronautView(astronaut: astronauts[0])
        }
    }
}
