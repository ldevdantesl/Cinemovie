//
//  TVSeriesDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    func didTapAnotherTVSeries(series: TVSeries)
    func didTapShareButton()
    func didTapRateButton()
    func didTapBackButton()
    func didSelectActor(_ actor: Cast)
    
    func didGetTVSeriesDetails(_ details: TVSeriesDetails)
    func didGetTVSeriesCast(_ cast: [Cast])
    func didGetTVSeriesVideos(_ videos: [Video])
    
    func didRecieveError(_ error: Error)
}

final class TVSeriesDetailsScreenPresenter {
    weak var view: TVSeriesDetailsScreenViewProtocol?
    var router: TVSeriesDetailsScreenRouterProtocol
    var interactor: TVSeriesDetailsScreenInteractorProtocol
    
    private var downloadGroup = DispatchGroup()
    private var seriesID: Int
    private var seriesDetails: TVSeriesDetails?
    private var seriesCast: [Cast] = []
    private var seriesVideos: [Video] = []

    init(seriesID: Int, interactor: TVSeriesDetailsScreenInteractorProtocol, router: TVSeriesDetailsScreenRouterProtocol) {
        self.seriesID = seriesID
        self.interactor = interactor
        self.router = router
    }
}

extension TVSeriesDetailsScreenPresenter: TVSeriesDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        downloadGroup.enter()
        interactor.getTVSeriesDetails(seriesID: seriesID)
        
        downloadGroup.enter()
        interactor.getTVSeriesCast(seriesID: seriesID)
        
        downloadGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard let details = seriesDetails else { return }
            view?.didGetAllTVSeriesData(details, cast: seriesCast, videos: seriesVideos)
        }
    }
    
    func didGetTVSeriesCast(_ cast: [Cast]) {
        self.seriesCast = cast
        downloadGroup.leave()
    }
    
    func didGetTVSeriesVideos(_ videos: [Video]) {
        self.seriesVideos = videos
        downloadGroup.leave()
    }
    
    func didGetTVSeriesDetails(_ details: TVSeriesDetails) {
        self.seriesDetails = details
        downloadGroup.leave()
    }
    
    func didRecieveError(_ error: any Error) {
        view?.didRecieveError(error.localizedDescription)
    }
    
    func didTapAnotherTVSeries(series: TVSeries) {
        router.navigateToAnotherTVSeries(series: series)
    }
    
    func didTapRateButton() {
        print("DID tap rate button")
    }
    
    func didTapShareButton() {
        guard let details = self.seriesDetails else { return }
        router.presentShareView(details: details)
    }
    
    func didSelectActor(_ actor: Cast) {
        router.presentActor(actor: actor)
    }
    
    func didTapBackButton() {
        router.goBack()
    }
}
