//
//  JSONDecoder+Activity.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

extension JSONDecoder {
    // Configure decoding strategy base on local models
    static var localActivityDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        return decoder
    }
    
    // Configure decoding strategy base on remote models
    static var remoteActivityDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        return decoder
    }
}
