//
//  NetworkService.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 17.02.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    var movies: MoviesAPISubServiceProtocol { get }
    var person: PersonAPISubServiceProtocol { get }
    var series: TVSeriesAPISubServiceProtocol { get }
    var accountList: AccountListAPISubServiceProtocol { get }
    var userList: UserListAPISubServiceProtocol { get }
    var search: SearchAPISubServiceProtocol { get }
    var other: OtherAPISubServiceProtocol { get }
    var auth: AuthenticationAPISubServiceProtocol { get }
}

final class CMNetworkService: NetworkServiceProtocol {
    let movies: MoviesAPISubServiceProtocol
    let person: PersonAPISubServiceProtocol
    let series: TVSeriesAPISubServiceProtocol
    let accountList: AccountListAPISubServiceProtocol
    let userList: UserListAPISubServiceProtocol
    let search: SearchAPISubServiceProtocol
    let other: OtherAPISubServiceProtocol
    let auth: AuthenticationAPISubServiceProtocol
    
    init(httpClient: HTTPClientProtocol, config: APIConfigurationProtocol, authContext: AuthContextProtocol) {
        self.movies = MoviesAPISubService(httpClient: httpClient, config: config, authContext: authContext)
        self.person = PersonAPISubService(httpClient: httpClient, config: config)
        self.series = TVSeriesAPISubService(httpClient: httpClient, config: config, authContext: authContext)
        self.accountList = AccountListAPISubService(httpClient: httpClient, authContext: authContext)
        self.userList = UserListAPISubService(httpClient: httpClient, authContext: authContext, config: config)
        self.search = SearchAPISubService(httpClient: httpClient)
        self.other = OtherAPISubService(httpClient: httpClient, config: config)
        self.auth = AuthenticationAPISubService(httpClient: httpClient, authContext: authContext)
    }
}
