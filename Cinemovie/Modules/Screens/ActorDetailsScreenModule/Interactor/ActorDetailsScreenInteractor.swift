//
//  ActorDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 19.03.2025
//

protocol ActorDetailsScreenInteractorProtocol: AnyObject {
}

final class ActorDetailsScreenInteractor: ActorDetailsScreenInteractorProtocol {
    weak var presenter: ActorDetailsScreenPresenterProtocol?
}
