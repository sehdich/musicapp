//
//  File.swift
//  
//
//  Created by Markus on 17.03.23.
//

import ComposableArchitecture
import Foundation
import Networking

extension AlbumService: DependencyKey {

    public static var liveValue = Self(
        albums: {
            // TODO: Improve: Move Endpoint to Route, extract base path, and think of injecting it
            let url = URL(string: "https://1979673067.rsc.cdn77.org/music-albums.json")!

            // TODO: Improve: Proper Caching, Timeouts, Base Headers etc. (-> HTTPClient)
            let urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
            let httpClient = StandardHTTPClient()

            return try await httpClient.execute(request: urlRequest, responseType: [Album].self)
        }
    )
}
