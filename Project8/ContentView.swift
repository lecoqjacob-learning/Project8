//
//  ContentView.swift
//  Shared
//
//  Created by Jacob LeCoq on 2/22/21.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    @State private var showingDates = true

    func crewNames(actualMission: Mission) -> String {
        var temp = [String]()
        for crewName in actualMission.crew {
            temp.append(crewName.name.capitalized)
        }

        return temp.joined(separator: ", ")
    }

    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(self.showingDates ? mission.formattedLaunchDate : crewNames(actualMission: mission))
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                showingDates.toggle()
            }, label: {
                Text("Show \(showingDates ? "Crew" : "Dates")")
            }))
            .navigationBarTitle("Moonshot")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
