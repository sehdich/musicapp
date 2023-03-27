//
//  File.swift
//  
//
//  Created by Markus on 26.03.23.
//

import Foundation

public struct AlbumService {
    public var albums: @Sendable () async throws -> [Album]
}
