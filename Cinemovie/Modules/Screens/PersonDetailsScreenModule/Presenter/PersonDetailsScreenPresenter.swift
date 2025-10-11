//
//  PersonDetailsScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 20.03.2025
//

import UIKit

protocol PersonDetailsScreenPresenterProtocol: AnyObject {
    func viewDidLoad()
    
    // MARK: - USER INITIATED
    func didTapBackButton()
    func didTapLogoImage(sourceID: String, sourceType: SourceTypes)
    func didTapMedia(media: any Media)
    
    // MARK: - DOWNLOAD
    func didGetPersonID(_ id: Int)
    func didGetPersonDetails(_ details: PersonDetails)
    func didGetPersonExternalSources(_ sources: ExternalSource)
    func didGetPersonMovies(_ movies: [Movie])
    func didGetPersonTVShows(_ tvShows: [TVSeries])
    func didGetPersonImages(_ images: [TMDBImage])
    
    // MARK: - PROPERTIES
    var visibleSections: [PersonDetailsScreenVC.Sections] { get set }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: Error)
}

final class PersonDetailsScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = PersonDetailsScreenVC.Sections
    typealias Items = PersonDetailsScreenVC.Items
    
    // MARK: - VIPER
    weak var view: PersonDetailsScreenViewProtocol?
    var router: PersonDetailsScreenRouterProtocol
    var interactor: PersonDetailsScreenInteractorProtocol
    var visibleSections: [PersonDetailsScreenVC.Sections] = []
    
    // MARK: - PROPERTIES
    private let downloadGroup = DispatchGroup()
    private let creditID: String?
    private var personID: Int?
    
    private var personDetails: PersonDetails?
    private var personExternalSources: ExternalSource?
    private var personMovies: [Movie] = []
    private var personTVSeries: [TVSeries] = []
    private var personImages: [TMDBImage] = []

    init(creditID: String, interactor: PersonDetailsScreenInteractorProtocol, router: PersonDetailsScreenRouterProtocol) {
        self.creditID = creditID
        self.personID = nil
        self.interactor = interactor
        self.router = router
    }
    
    init(personID: Int, interactor: PersonDetailsScreenInteractorProtocol, router: PersonDetailsScreenRouterProtocol) {
        print("PersonID: ", personID)
        self.creditID = nil
        self.personID = personID
        self.interactor = interactor
        self.router = router
    }
}

extension PersonDetailsScreenPresenter: PersonDetailsScreenPresenterProtocol {
    func viewDidLoad() {
        defer {
            downloadGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                self.didGetAllPersonData()
            }
        }
        
        guard let personID = personID else {
            let creditID = self.creditID ?? ""
            downloadGroup.enter()
            interactor.getPersonID(creditID: creditID)
            return
        }
        
        downloadGroup.enter()
        self.interactor.getPersonDetails(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonExternalSources(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonMovies(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonTVShows(personID: personID)
        
        downloadGroup.enter()
        self.interactor.getPersonImages(personID: personID)
    }
    
    // MARK: - USER INITIATED
    func didTapBackButton() {
        print("Presenter Did Tap backbutton called")
        router.goBack()
    }
    
    func didTapLogoImage(sourceID: String, sourceType: SourceTypes) {
        router.openSource(sourceID: sourceID, sourceType: sourceType)
    }
    
    func didTapMedia(media: any Media) {
        switch media {
        case let movie as Movie: router.navigateToMovie(movie: movie)
        case let series as TVSeries: router.navigateToSeries(series: series)
        default: break
        }
    }
    
    // MARK: - DOWNLOAD
    func didGetPersonID(_ id: Int) {
        print("PersonID: \(id)")
        self.personID = id
        
        downloadGroup.enter()
        self.interactor.getPersonDetails(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonExternalSources(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonMovies(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonTVShows(personID: id)
        
        downloadGroup.enter()
        self.interactor.getPersonImages(personID: id)
        
        downloadGroup.leave()
    }
    
    func didGetPersonDetails(_ details: PersonDetails) {
        self.personDetails = details
        downloadGroup.leave()
    }
    
    func didGetPersonExternalSources(_ sources: ExternalSource) {
        self.personExternalSources = sources
        downloadGroup.leave()
    }
    
    func didGetPersonMovies(_ movies: [Movie]) {
        self.personMovies = movies.removingMediaWithoutPoster().filteringByMinimumPopularity()
        downloadGroup.leave()
    }
    
    func didGetPersonTVShows(_ tvShows: [TVSeries]) {
        let talkGenreId = GenreHelper.shared.getSeriesGenreID(for: .talk)
        let realityGenreID = GenreHelper.shared.getSeriesGenreID(for: .reality)
        let warPoliticsGenreId = GenreHelper.shared.getSeriesGenreID(for: .warPolitics)
        let newsGenreId = GenreHelper.shared.getSeriesGenreID(for: .news)
        self.personTVSeries = tvShows.filter { !$0.genreIDS.isEmpty }.filter {
            !$0.genreIDS.contains(where: { $0 == talkGenreId || $0 == realityGenreID || $0 == warPoliticsGenreId || $0 == newsGenreId })
        }.removingMediaWithoutPoster().sortByPopularity()
        downloadGroup.leave()
    }
    
    func didGetPersonImages(_ images: [TMDBImage]) {
        self.personImages = images
        downloadGroup.leave()
    }
    
    // MARK: - ERROR HANDLING
    func didRecieveError(_ error: any Error) {
        view?.didRecieveError(error.localizedDescription)
    }
    
    // MARK: - PRIVATE FUNC
    private func didGetAllPersonData() {
        view?.downloadingView.hide()
        guard let personDetails = self.personDetails else {
            self.view?.didRecieveError("Can't get person details")
            return
        }
        
        var sectionsAndTheirItems: [(section: Sections, items: [Items])] = []
        
        if !personImages.isEmpty {
            let imagesVM = PersonImagesCellViewModel(images: personImages) { [weak self] in
                guard let self = self else { return }
                self.didTapBackButton()
            }
            sectionsAndTheirItems.append((Sections.images, [.imageCell(imagesVM)]))
            
            let infoVM = PersonInfoCellViewModel(personDetails: personDetails, externalSource: self.personExternalSources) { [weak self] id, sourceType in
                guard let self = self else { return }
                self.didTapLogoImage(sourceID: id, sourceType: sourceType)
            }
            sectionsAndTheirItems.append((Sections.info, [.infoVM(infoVM)]))
        } else {
            let infoVM = PersonInfoCellViewModel(personDetails: personDetails, externalSource: self.personExternalSources) { [weak self] in
                guard let self = self else { return }
                self.didTapBackButton()
            } didTapSource: { [weak self] id, sourceType in
                guard let self = self else { return }
                self.didTapLogoImage(sourceID: id, sourceType: sourceType)
            }
            sectionsAndTheirItems.append((Sections.info, [.infoVM(infoVM)]))
        }
        
        if !personDetails.biography.isEmpty {
            let overviewVM = OverviewCellViewModel(overviewText: personDetails.biography)
            sectionsAndTheirItems.append((Sections.overview, [.overviewVM(overviewVM)]))
        }
        
        if !self.personMovies.isEmpty {
            let moviesVM = MediaListCellViewModel(
                mediaItems: self.personMovies, listName: "Movies",
                listSubtitle: "Movies in which \(personDetails.name) has played"
            ) { [weak self] in
                guard let self = self else { return }
                self.didTapMedia(media: $0)
            }
            sectionsAndTheirItems.append((Sections.movies, [.mediaListVM(moviesVM)]))
        }
        
        if !self.personTVSeries.isEmpty {
            let seriesVM = MediaListCellViewModel(
                mediaItems: self.personTVSeries, listName: "TV Series",
                listSubtitle: "TV Series in which \(personDetails.name) has played"
            ) { [weak self] in
                guard let self = self else { return }
                self.didTapMedia(media: $0)
            }
            sectionsAndTheirItems.append((Sections.tvSeries, [.mediaListVM(seriesVM)]))
        }
        
        if self.personMovies.isEmpty && self.personTVSeries.isEmpty {
            let unavailableVm = UnavailableInfoCellViewModel(
                title: "Additional information is not available",
                subtitle: "We couldn't find any movies or TV series linked to this person.",
                image: UIImage(named: ImageNames.empty.rawValue)
            )
            sectionsAndTheirItems.append((Sections.unavailable, [.unavailableVM(unavailableVm)]))
        }
        
        self.visibleSections = sectionsAndTheirItems.map { $0.section }
        
        self.view?.applySnapshot(
            sections: visibleSections,
            itemsBySection: Dictionary(uniqueKeysWithValues: sectionsAndTheirItems)
        )
    }
}
