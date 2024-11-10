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
    private let decoder: JSONDecoder
    
    init(
        url: URL,
        client: HTTPClient,
        decoder: JSONDecoder = .remoteActivityDecoder
    ) {
        self.url = url
        self.client = client
        self.decoder = decoder
    }
    
    func load(completion: @escaping (ActivityLoader.Result) -> Void) {
        client.request(from: url, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success((data, response)):
                guard response.statusCode == RemoteActivityLoader.OK_200 else {
                    completion(.failure(Error.invalidData))
                    return
                }
                
                do {
                    let decodedData = try self.decoder.decode(RemoteActivityContainer.self, from: data)
                    let mappedData = RemoteActivityMapper.map(decodedData)
                    
                    completion(.success(mappedData))
                } catch {
                    completion(.failure(Error.invalidData))
                }
                
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

