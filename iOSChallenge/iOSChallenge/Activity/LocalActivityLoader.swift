//
//  LocalActivityLoader.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

final class LocalActivityLoader: ActivityLoader {
    private let url: URL
    private let decoder: JSONDecoder
    
    init(url: URL, decoder: JSONDecoder = .localActivityDecoder) {
        self.url = url
        self.decoder = decoder
    }

    func load(completion: @escaping (ActivityLoader.Result) -> Void) {
        guard url.isFileURL else {
            completion(.failure(Error.invalidFileURL))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try decoder.decode(ActivityContainer.self, from: data)
            
            completion(.success(decodedData))
        } catch {
            completion(.failure(Error.invalidData))
        }
    }
}

extension LocalActivityLoader {
    enum Error: Swift.Error {
        case invalidData
        case invalidFileURL
    }
}
