//
//  JSONDecoder+Activity.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

extension JSONDecoder {
    static var localActivityDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dataDecodingStrategy = .deferredToData
        
        return decoder
    }
    
    static var remoteActivityDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        
        return decoder
    }
}
