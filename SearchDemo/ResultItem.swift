//
//  ResultItem.swift
//  SearchDemo
//
//  Created by Patrick Lin on 26/09/2017.
//  Copyright © 2017 Soocii. All rights reserved.
//

import ObjectMapper

class ResultItem: Mappable {
    
    var artworkUrl60: String?
    
    var trackViewUrl: String?
    
    var trackName: String?
    
    var primaryGenreName: String?
    
    var genres: [String]?
    
    // Init Methods
    
    required init?(map: Map) {
        
        
        
    }
    
    func mapping(map: Map) {
        
        artworkUrl60 <- map["artworkUrl60"]
        
        trackViewUrl <- map["trackViewUrl"]
        
        trackName <- map["trackName"]
        
        primaryGenreName <- map["primaryGenreName"]
        
        genres <- map["genres"]
        
    }

}
