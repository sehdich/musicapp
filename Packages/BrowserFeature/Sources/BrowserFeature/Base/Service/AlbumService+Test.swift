//
//  File.swift
//  
//
//  Created by Markus on 26.03.23.
//

import ComposableArchitecture
import Foundation

extension AlbumService: TestDependencyKey {

    public static let testValue = Self(
        albums: unimplemented("\(Self.self).albums")
    )

    public static let previewValue = Self(
        albums: {
            [
                .mock(id: "1"),
                .mock(id: "2")
            ]
        }
    )

    public static let noop = Self(
        albums: { [] }
    )
}
