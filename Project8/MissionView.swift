//
//  MissionView.swift
//  Project8
//
//  Created by Jacob LeCoq on 2/22/21.
//

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut

        var isCommander: Bool {
            return role == "Commander"
        }
    }

    let mission: Mission
    let astronauts: [CrewMember]

    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission

        var matches = [CrewMember]()

        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }

        self.astronauts = matches
    }

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { imageGeometry in
                        Image(self.mission.image)
                            .resizable()
                            .scaledToFit()
                            .padding(.top)
                            .frame(width: imageGeometry.size.width, height: imageGeometry.size.height)
                            .scaleEffect(1 - self.scaleFactor(geometry: fullView, imageGeometry: imageGeometry))
                            .offset(x: 0, y: self.scaleFactor(geometry: fullView, imageGeometry: imageGeometry) * imageGeometry.size.height / 2)
                            
                    }
                    .frame(height: fullView.size.width * 0.75)

                    Text(self.mission.formattedLaunchDate)
                        .font(.headline)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.top)

                    Text(self.mission.description)
                        .padding()

                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))

                                HStack {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(crewMember.astronaut.name)
                                                .font(.headline)
                                        }
                                        Text(crewMember.role)
                                            .foregroundColor(.secondary)
                                    }

                                    if crewMember.isCommander {
                                        Spacer()

                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 26))
                                    }
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    private func scaleFactor (geometry: GeometryProxy, imageGeometry: GeometryProxy) -> CGFloat{
        let imagePosition = imageGeometry.frame(in: .global).minY
        let safeAreaHeight = geometry.safeAreaInsets.top
        return (safeAreaHeight - imagePosition) / 500
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        NavigationView {
            MissionView(mission: missions[5], astronauts: astronauts)
        }
    }
}
