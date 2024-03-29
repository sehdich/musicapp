//
//  PreviewApp.swift
//  BrowserFeaturePreviewApp
//
//  Created by Markus Flandorfer on 26.03.23.
//

import BrowserFeature
import ComposableArchitecture
import SwiftUI

@main
struct PreviewApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                List {
                    NavigationLink("Show Browser (previewValue)") {
                        AlbumBrowserView(
                            store: Store(
                                initialState: AlbumBrowserReducer.State(),
                                reducer: AlbumBrowserReducer()
                                    .dependency(\.albumService, .previewValue)
                            )
                        )
                    }
                    NavigationLink("Show Browser (liveValue)") {
                        AlbumBrowserView(
                            store: Store(
                                initialState: AlbumBrowserReducer.State(),
                                reducer: AlbumBrowserReducer()
                            )
                        )
                    }
                    NavigationLink("Show Browser (empty)") {
                        AlbumBrowserView(
                            store: Store(
                                initialState: AlbumBrowserReducer.State(),
                                reducer: AlbumBrowserReducer()
                                    .dependency(\.albumService, .noop)
                            )
                        )
                    }
                }

            }
        }
    }
}
