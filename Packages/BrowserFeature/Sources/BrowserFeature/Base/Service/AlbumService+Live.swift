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
            let url = URL(string: "https://1979673067.rsc.cdn77.org/music-albums.json")!
            var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
            urlRequest.timeoutInterval = 2.0
            urlRequest.setValue("Accept", forHTTPHeaderField: "application/json")

            let httpClient = StandardHTTPClient() { request in
                try await URLSession.shared.data(for: request)
            }

            return try await httpClient.execute(request: urlRequest, responseType: [Album].self)
        }
    )
}
