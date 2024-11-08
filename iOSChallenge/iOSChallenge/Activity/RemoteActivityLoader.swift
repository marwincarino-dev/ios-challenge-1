//
//  RemoteActivityLoader.swift
//  iOSChallenge
//
//  Created by Marwin Cariño on 11/8/24.
//

import Foundation

final class RemoteActivityLoader: ActivityLoader {
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (ActivityLoader.Result) -> Void) {
        client.request(from: url, completion: { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case let .success((data, response)):
                guard response.statusCode == RemoteActivityLoader.OK_200 else {
                    completion(.failure(Error.invalidData))
                    return
                }
                
                completion(.success([data]))
                
                return
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        })
    }
}

extension RemoteActivityLoader {
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}

private extension RemoteActivityLoader {
    static let OK_200 = 200
}
