//
//  SettingsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 30.01.2025
//

protocol SettingsScreenInteractorProtocol: AnyObject {
}

final class SettingsScreenInteractor: SettingsScreenInteractorProtocol {
    weak var presenter: SettingsScreenPresenterProtocol?
}
