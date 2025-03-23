//
//  TVSeriesDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class TVSeriesDetailsScreenPresenter {
    weak var view: TVSeriesDetailsScreenViewProtocol?
    var router: TVSeriesDetailsScreenRouterProtocol
    var interactor: TVSeriesDetailsScreenInteractorProtocol
    
    private var downloadGroup = DispatchGroup()
    private var seriesID: Int

    init(seriesID: Int, interactor: TVSeriesDetailsScreenInteractorProtocol, router: TVSeriesDetailsScreenRouterProtocol) {
        self.seriesID = seriesID
        self.interactor = interactor
        self.router = router
    }
}

extension TVSeriesDetailsScreenPresenter: TVSeriesDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        
    }
}
