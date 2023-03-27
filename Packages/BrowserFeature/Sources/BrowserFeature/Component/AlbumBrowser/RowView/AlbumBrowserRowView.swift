//
//  SwiftUIView.swift
//  
//
//  Created by Markus on 26.03.23.
//

import SwiftUI

struct AlbumBrowserRowView: View {

    let headline: String
    let subline: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Text(subline)
                .foregroundColor(.gray)
        }
    }
}

struct AlbumBrowserRowView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumBrowserRowView(
            headline: "Headline",
            subline: "Subline"
        )
        .previewLayout(.sizeThatFits)
    }
}
