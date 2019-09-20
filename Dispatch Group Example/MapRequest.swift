//
//  MapRequest.swift
//  Dispatch Group Example
//
//  Created by Bernardo Silva on 11/09/19.
//  Copyright © 2019 Bernardo Silva. All rights reserved.
//

import Foundation
import MapKit

class MapRequest {
    static func search(sentence: String,
                       completion: @escaping (MKLocalSearch.Response?, Error?) -> Void){
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = sentence
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            completion(response, error)
        }
    }
}

