//
//  MovieDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

import UIKit

protocol MovieDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()

    func didTapAnotherMovie(movie: Movie)
    func didTapIMDBImage()
    func didTapShareButton()
    func didTapRateButton()
    func didTapBackButton()
    func didSelectActor(_ actor: Cast)
    
    func didGetMovieDetails(_ details: MovieDetails)
    func didRecieveError(_ error: String)
    func didGetMovieCast(cast: [Cast], crew: [Cast])
    func didGetMovieRecommendations(queryMovies: [Movie])
    func didGetMovieVideos(videos: [Video])
    func didGetMovieReviews(_ reviews: [Review], reviewCount: Int)
}

final class MovieDetailsScreenPresenter {
    weak var view: MovieDetailsScreenViewProtocol?
    var router: MovieDetailsScreenRouterProtocol
    var interactor: MovieDetailsScreenInteractorProtocol
    
    private let movieID: Int
    
    private let dispatchGroup = DispatchGroup()
    
    private var movieDetails: MovieDetails?
    private var movieVideos: [Video]?
    private var movieCast: [Cast]?
    private var movieCrew: [Cast]?
    private var movieRecommends: [Movie]?
    private var movieReviews: [Review]?
    private var movieReviewCount: Int?

    init(movieID: Int, interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.movieID = movieID
        self.interactor = interactor
        self.router = router
    }
}

extension MovieDetailsScreenPresenter: MovieDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        dispatchGroup.enter()
        interactor.getMovieDetails(movieID: movieID)
        
        dispatchGroup.enter()
        interactor.getMovieCast(movieID: movieID)
        
//        dispatchGroup.enter()
//        interactor.getMovieRecommendations(movieID: movieID)
//        
//        dispatchGroup.enter()
//        interactor.getMovieVideos(movieID: movieID)
//        
//        dispatchGroup.enter()
//        interactor.getMovieReviews(movieID: movieID)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            guard let details = self.movieDetails else { return }
            self.view?.didDownloadAllData(
                details: details, videos: movieVideos,
                cast: movieCast, crew: movieCrew,
                recommends: movieRecommends, reviews: movieReviews,
                reviewCount: movieReviewCount
            )
            print("Gave all data")
        }
    }

    func didRecieveError(_ error: String) {
        view?.didRecieveError(error)
    }
    
    func didTapAnotherMovie(movie: Movie) {
        router.navigateToAnotherMovie(movie: movie)
    }
    
    func didTapIMDBImage() {
        guard let imdbURL = URLHelper.getImdbURL(withID: movieDetails?.imdbID) else { return }
        AppOpener.openURL(imdbURL)
    }
    
    func didTapRateButton() {
        print("DID tap rate button")
    }
    
    func didTapShareButton() {
        guard let details = self.movieDetails else { return }
        router.presentShareView(movie: details)
    }
    
    func didSelectActor(_ actor: Cast) {
        router.presentActor(actor: actor)
    }
    
    func didGetMovieReviews(_ reviews: [Review], reviewCount: Int) {
        movieReviews = reviews
        movieReviewCount = reviewCount
        dispatchGroup.leave()
    }
    
    func didGetMovieVideos(videos: [Video]) {
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
    
    func didGetMovieRecommendations(queryMovies: [Movie]) {
        movieRecommends = queryMovies
        dispatchGroup.leave()
    }
    
    func didTapBackButton() {
        router.goBack()
    }
}
