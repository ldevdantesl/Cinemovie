//
//  MovieDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

protocol MovieDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()

    func didGetMovieDetails(_ details: MovieDetails)
    func didRecieveError(_ error: String)
    func didGetMovieCast(cast: [Cast], crew: [Cast])
    func didGetMovieRecommendations(queryMovies: [QueryMovie])
    func didGetMovieVideos(videos: [DomainVideo])
    func didGetMovieReviews(_ reviews: [DomainReview], reviewCount: Int)
    func didTapAnotherMovie(movie: QueryMovie)
}

final class MovieDetailsScreenPresenter {
    weak var view: MovieDetailsScreenViewProtocol?
    var router: MovieDetailsScreenRouterProtocol
    var interactor: MovieDetailsScreenInteractorProtocol
    
    private let dispatchGroup = DispatchGroup()
    
    private var movieDetails: MovieDetails?
    private var movieVideos: [DomainVideo]?
    private var movieCast: [Cast]?
    private var movieCrew: [Cast]?
    private var movieRecommends: [QueryMovie]?
    private var movieReviews: [DomainReview]?
    private var movieReviewCount: Int?

    init(interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MovieDetailsScreenPresenter: MovieDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        dispatchGroup.enter()
        interactor.getMovieDetails()
        
        dispatchGroup.enter()
        interactor.getMovieCast()
        
        dispatchGroup.enter()
        interactor.getMovieRecommendations()
        
        dispatchGroup.enter()
        interactor.getMovieVideos()
        
        dispatchGroup.enter()
        interactor.getMovieReviews()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard let details = self.movieDetails else { return }
            self.view?.didDownloadAllData(
                details: details, videos: movieVideos,
                cast: movieCast, crew: movieCrew,
                recommends: movieRecommends, reviews: movieReviews,
                reviewCount: movieReviewCount
            )
        }
    }
    
    func didRecieveError(_ error: String) {
        view?.didRecieveError(error)
    }
    
    func didTapAnotherMovie(movie: QueryMovie) {
        router.navigateToAnotherMovie(movie: movie)
    }
    
    func didGetMovieReviews(_ reviews: [DomainReview], reviewCount: Int) {
        movieReviews = reviews
        movieReviewCount = reviewCount
        dispatchGroup.leave()
    }
    
    func didGetMovieVideos(videos: [DomainVideo]) {
        movieVideos = videos
        dispatchGroup.leave()
    }
    
    func didGetMovieDetails(_ details: MovieDetails) {
        movieDetails = details
        dispatchGroup.leave()
    }
    
    func didGetMovieCast(cast: [Cast], crew: [Cast]) {
        movieCast = cast
        movieCrew = crew
        dispatchGroup.leave()
    }
    
    func didGetMovieRecommendations(queryMovies: [QueryMovie]) {
        movieRecommends = queryMovies
        dispatchGroup.leave()
    }
}
