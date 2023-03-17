//
//  File.swift
//  
//
//  Created by Markus on 17.03.23.
//

import Dependencies
import Foundation

public extension DependencyValues {

    var albumService: AlbumService {
        get { self[AlbumService.self] }
        set { self[AlbumService.self] = newValue }
    }
}
