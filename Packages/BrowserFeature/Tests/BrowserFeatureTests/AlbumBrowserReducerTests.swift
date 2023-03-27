@testable import BrowserFeature
import ComposableArchitecture
import XCTest

@MainActor
final class AlbumBrowserReducerTests: XCTestCase {

    func testSuccessfullyLoadAlbums() async throws {
        let store = TestStore(
            initialState: AlbumBrowserReducer.State(),
            reducer: AlbumBrowserReducer()
        )
        let exepctedAlbumes: [Album] = [
            .mock(id: "1"),
            .mock(id: "2")
        ]

        store.dependencies.albumService.albums = { exepctedAlbumes }

        await store.send(.loadAlbums)
        await store.receive(.albumResponse(TaskResult { exepctedAlbumes })) {
            $0.albums = exepctedAlbumes
        }
    }

    func testLoadAlbumsFailure() async throws {
        let store = TestStore(
            initialState: AlbumBrowserReducer.State(),
            reducer: AlbumBrowserReducer()
        )

        enum AlbumFailure: Error {
            case test
        }

        store.dependencies.albumService.albums = { throw AlbumFailure.test }

        await store.send(.loadAlbums)
        await store.receive(.albumResponse(.failure(AlbumFailure.test)))
    }

    func testSearchAlbumsWithResult() async throws {
        let mainQueue = DispatchQueue.test

        let album1 = Album(id: "1", album: "My Album", artist: "Met", label: "label", tracks: ["track1, track2"], year: "2020")
        let album2 = Album(id: "1", album: "Your", artist: "Met", label: "Foo", tracks: ["music, music2"], year: "2020")

        let responseAlbums: [Album] = [album1, album2]
        let searchText = "Your music"

        let store = TestStore(
            initialState: AlbumBrowserReducer.State(
                albums: responseAlbums
            ),
            reducer: AlbumBrowserReducer()
                .dependency(\.mainQueue, mainQueue.eraseToAnyScheduler())
        )

        await store.send(.searchTextChanged(searchText)) {
            $0.searchText = searchText
        }
        await store.send(.searchTextChangeDebounced)
        await mainQueue.advance(by: 0.2)
        await store.receive(.search(responseAlbums))
        await store.receive(.showSearchResult([album2])) {
            $0.searchResult = .result([album2])
        }
    }

    func testSearchAlbumsWithoutResultNonExhaustive() async throws {
        let mainQueue = DispatchQueue.test

        let album1 = Album(id: "1", album: "My Album", artist: "Met", label: "label", tracks: ["track1, track2"], year: "2020")
        let album2 = Album(id: "1", album: "Your", artist: "Met", label: "Foo", tracks: ["music, music2"], year: "2020")

        let responseAlbums: [Album] = [album1, album2]
        let searchText = "FOO"

        let store = TestStore(
            initialState: AlbumBrowserReducer.State(
                albums: responseAlbums
            ),
            reducer: AlbumBrowserReducer()
                .dependency(\.mainQueue, mainQueue.eraseToAnyScheduler())
        )

        store.exhaustivity = .off

        await store.send(.searchTextChanged(searchText))
        await store.send(.searchTextChangeDebounced)
        await mainQueue.advance(by: 0.2)
        await store.receive(.search(responseAlbums))
        await store.receive(.showSearchResult([])) {
            $0.searchResult = .empty
        }
    }
}
