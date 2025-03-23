//
//  TVSeriesDetailsScreenInteractor.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 23.03.2025
//

import UIKit

protocol TVSeriesDetailsScreenInteractorProtocol: AnyObject {
    func getTVSeriesDetails(seriesID: Int)
    func getTVSeriesCast(seriesID: Int)
    func getTVSeriesRecommendations(seriesID: Int)
    func getTVSeriesVideos(seriesID: Int)
    func getTVSeriesReviews(seriesID: Int)
}

final class TVSeriesDetailsScreenInteractor: TVSeriesDetailsScreenInteractorProtocol {
    weak var presenter: TVSeriesDetailsScreenPresenterProtocol?
    weak var tmdbService: TMDBService?
    
    init(tmdbService: TMDBService?) {
        self.tmdbService = tmdbService
    }
    
    func getTVSeriesDetails(seriesID: Int) { }
    
    func getTVSeriesCast(seriesID: Int) { }
    
    func getTVSeriesRecommendations(seriesID: Int) { }
    
    func getTVSeriesVideos(seriesID: Int) { }
    
    func getTVSeriesReviews(seriesID: Int) { }
}
