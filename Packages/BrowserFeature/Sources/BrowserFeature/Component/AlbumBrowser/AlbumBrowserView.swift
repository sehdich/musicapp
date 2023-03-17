//
//  SwiftUIView.swift
//  
//
//  Created by Markus on 17.03.23.
//

import ComposableArchitecture
import SwiftUI

public struct AlbumBrowserView: View {

    let store: StoreOf<AlbumBrowserReducer>

    public init(store: StoreOf<AlbumBrowserReducer>) {
        self.store = store
    }

    // TODO: Proper Loading indication, display Errors...
    public var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.albums) { album in
                    AlbumBrowserRowView(headline: album.album, subline: album.artist)
                }
            }
            .task {
                await viewStore.send(.task).finish()
            }
            .refreshable {
                await viewStore.send(.refresh).finish()
            }
            .searchable(
                // Note: There is a glitch when using that on Simulator - Maybe use real device instead.
                text: viewStore.binding(
                    get: \.searchText,
                    send: AlbumBrowserReducer.Action.searchTextChanged
                ),
                placement: .navigationBarDrawer(displayMode: .automatic)
            ) {
                viewForSearchResult(viewStore: viewStore)
            }
            .task(id: viewStore.searchText) {
                await viewStore.send(.searchTextChangeDebounced).finish()
            }
        }
        .navigationTitle(String(localized: "album_browser_title"))
    }

    @ViewBuilder
    private func viewForSearchResult(
        viewStore: ViewStore<AlbumBrowserReducer.State, AlbumBrowserReducer.Action>
    ) -> some View {
        switch viewStore.searchResult {
            case .empty:
                // Move to ErrorView
                Text(String(localized: "album_browser_serch_empty"))
                    .padding(.top, 20)

            case .result(let albums):
                    ForEach(albums) { album in
                        // Move to SearchResultRowView
                        Text(album.album)
                    }
                    .listRowSeparator(.hidden)

            default:
                EmptyView()
        }
    }
}

// MARK: - Previews

struct AlbumBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumBrowserView(
            store: Store(
                initialState: AlbumBrowserReducer.State(
                    albums: [
                        .mock(),
                        .mock()
                    ]
                ),
                reducer: AlbumBrowserReducer()
            )
        )
    }
}
