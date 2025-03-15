//
//  MovieDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 18.02.2025
//

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

    init(interactor: MovieDetailsScreenInteractorProtocol, router: MovieDetailsScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension MovieDetailsScreenPresenter: MovieDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        interactor.getMovieDetails()
        interactor.getMovieCast()
        interactor.getMovieRecommendations()
        interactor.getMovieVideos()
        interactor.getMovieReviews()
    }
    
    func didTapAnotherMovie(movie: QueryMovie) {
        router.navigateToAnotherMovie(movie: movie)
    }
    
    func didGetMovieReviews(_ reviews: [DomainReview], reviewCount: Int) {
        view?.didGetMovieReviews(reviews: reviews, reviewCount: reviewCount)
    }
    
    func didGetMovieVideos(videos: [DomainVideo]) {
        view?.didGetMovieVideos(videos: videos)
    }
    
    func didRecieveError(_ error: String) {
        view?.didRecieveError(error)
    }
    
    func didGetMovieDetails(_ details: MovieDetails) {
        view?.didGetMovieDetails(details)
    }
    
    func didGetMovieCast(cast: [Cast], crew: [Cast]) {
        view?.didGetMovieCast(cast: cast, crew: crew)
    }
    
    func didGetMovieRecommendations(queryMovies: [QueryMovie]) {
        view?.didGetMovieRecommendations(movies: queryMovies)
    }
}
