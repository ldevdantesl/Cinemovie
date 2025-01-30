//
//  SearchScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SearchScreenInteractorProtocol: AnyObject {
}

final class SearchScreenInteractor: SearchScreenInteractorProtocol {
    weak var presenter: SearchScreenPresenterProtocol?
}
