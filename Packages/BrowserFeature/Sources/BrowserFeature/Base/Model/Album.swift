//
//  File.swift
//  
//
//  Created by Markus on 26.03.23.
//

import Foundation

public struct Album: Codable, Equatable, Identifiable {
    public let id: String          // BE API 2be Questioned: Format - UUID
    public let album: String
    public let artist: String
    public let label: String
    public let tracks: [String]
    public let year: String        // BE API 2be Questioned: Int/Date
}

extension Album {
    static func mock(id: String = UUID().uuidString) -> Self {
        Album(
            id: id,
            album: "album",
            artist: "artist",
            label: "label",
            tracks: ["track1", "track2"],
            year: "2009"
        )
    }
}
