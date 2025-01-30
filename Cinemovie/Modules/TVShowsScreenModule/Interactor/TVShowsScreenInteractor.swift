//
//  TVShowsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol TVShowsScreenInteractorProtocol: AnyObject {
}

final class TVShowsScreenInteractor: TVShowsScreenInteractorProtocol {
    weak var presenter: TVShowsScreenPresenterProtocol?
}
