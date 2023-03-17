//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Markus on 17.03.23.
//

import BrowserFeature
import ComposableArchitecture
import SwiftUI

@main
struct MusicAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AlbumBrowserView(
                    store: Store(
                        initialState: AlbumBrowserReducer.State(),
                        reducer: AlbumBrowserReducer()
                    )
                )
            }
        }
    }
}
