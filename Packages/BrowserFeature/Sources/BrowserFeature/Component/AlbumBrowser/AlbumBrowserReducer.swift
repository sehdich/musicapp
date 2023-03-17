//
//  File.swift
//  
//
//  Created by Markus on 17.03.23.
//

import ComposableArchitecture
import Foundation

public struct AlbumBrowserReducer: ReducerProtocol {

    public struct State: Equatable {
        var albums: [Album]
        var searchText: String
        var searchResult: SearchResult?

        public enum SearchResult: Equatable {
            case result([Album])
            case empty
        }

        public init(
            albums: [Album] = [],
            searchText: String = ""
        ) {
            self.albums = albums
            self.searchText = searchText
        }
    }

    public enum Action: Equatable {
        case task
        case refresh
        case loadAlbums
        case albumResponse(TaskResult<[Album]>)

        case searchTextChanged(String)
        case searchTextChangeDebounced
        case search([Album])
        case showSearchResult([Album])
    }

    public init() {}

    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.albumService) var albumService

    private enum SearchAlbumsID {}

    public var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
                case .task, . refresh:
                    return .task {
                        .loadAlbums
                    }

                case .loadAlbums:
                    return .task {
                        await .albumResponse(
                            TaskResult {
                                try await albumService.albums().sorted {
                                    $0.album < $1.album
                                }
                            }
                        )
                    }

                case .albumResponse(.success(let albums)):
                    state.albums = albums
                    return .none

                case .albumResponse(.failure): // .failure(let error)
                    // TODO: Show Errors
                    return .none

                case .searchTextChanged(let searchText):
                    state.searchText = searchText

                    guard !searchText.isEmpty else {
                        state.searchResult = nil
                        return .cancel(id: SearchAlbumsID.self)
                    }
                    return .none

                case .searchTextChangeDebounced:
                    guard !state.searchText.isEmpty else {
                        return .none
                    }

                    return .task { [albums = state.albums] in
                        try await mainQueue.sleep(for: .seconds(0.1))
                        return .search(albums)
                    }
                    .cancellable(id: SearchAlbumsID.self)

                case .search(let albums):
                    return .task { [searchText = state.searchText] in
                        // Preparing search tags could be another separat action
                        let searchTags = searchText
                            .lowercased()
                            .trimmingCharacters(in: .whitespaces)
                            .split(separator: " ")
                        let filteredAlbums = filterAlbums(bySearchTags: searchTags, albums: albums)
                        return .showSearchResult(filteredAlbums)
                    }

                case .showSearchResult(let albums):
                    state.searchResult = albums.isEmpty ? .empty : .result(albums)
                    return .none
            }
        }
    }

    private func filterAlbums(bySearchTags searchTags: Array<Substring>, albums: [Album]) -> [Album] {
        Array(
            albums
                .filter { album in
                    searchTags.contains(where: { album.album.range(of: $0, options: .caseInsensitive) != nil }) ||
                    searchTags.contains(where: { album.artist.range(of: $0, options: .caseInsensitive) != nil }) ||
                    searchTags.contains(where: { album.tracks.joined().range(of: $0, options: .caseInsensitive) != nil })
                }
        )
    }
}


