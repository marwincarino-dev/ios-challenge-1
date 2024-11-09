//
//  ActivityHTTPClient.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/9/24.
//

import Foundation

final class ActivityHTTPClient: HTTPClient {
    // For demo purposes only, not implemented with actual API
    func request(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        let error = NSError(domain: "", code: 1)
        completion(.failure(error))
    }
}
