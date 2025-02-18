//
//  MovieDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

protocol MovieDetailsScreenInteractorProtocol: AnyObject {
}

final class MovieDetailsScreenInteractor: MovieDetailsScreenInteractorProtocol {
    weak var presenter: MovieDetailsScreenPresenterProtocol?
}
