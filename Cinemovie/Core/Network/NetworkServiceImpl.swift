//
//  NetworkServiceImpl.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

final class NetworkServiceImpl: NetworkService {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: APIResponse>(
        _ endpoint: any Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) where T: APIResponse {
        
        guard let urlRequest = endpoint.urlRequest else {
            completion(.failure(.invalidURL))
            return
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error.localizedDescription)))
            }
        }
        .resume()
    }
}
