//
//  SplashScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SplashScreenInteractorProtocol: AnyObject {
}

final class SplashScreenInteractor: SplashScreenInteractorProtocol {
    weak var presenter: SplashScreenPresenterProtocol?
}
