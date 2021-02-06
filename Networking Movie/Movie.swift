//
//  Movie.swift
//  Networking Movie
//
//  Created by Korlan Omarova on 06.02.2021.
//

import Foundation

struct Movie {
    var id: Int
    var posterPath: String
    var date: String
    var name: String
    var overview: String
    
    init(json: [String: Any]) throws{
        guard let id = json["id"] as? Int, let posterPath = json["poster_path"] as? String, let name = json["original_title"] as? String, let date = json["release_date"] as? String,
              let overview = json["overview"] as? String else {
            throw NSError(domain: "Error parsing json", code: 0, userInfo: nil)
        }
        self.id = id
        self.posterPath = posterPath
        self.date = date
        self.name = name
        self.overview = overview
    }
}
