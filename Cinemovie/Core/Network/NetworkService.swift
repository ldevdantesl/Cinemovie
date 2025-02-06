//
//  NetworkService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.01.2025.
//

import Foundation

protocol NetworkService: AnyObject {
    func request<T: APIResponse>(
        _ endpoint: Endpoint,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
