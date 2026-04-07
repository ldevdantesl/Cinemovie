//
//  SearchScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

import UIKit

protocol SearchScreenPresenterProtocol: AnyObject {
    // MARK: - STARTING
    func viewDidLoaded()
    
    // MARK: - QUERY
    func didReceiveSearchResults(_ items: [MediaProtocol])
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error)
}

final class SearchScreenPresenter {
    // MARK: - TYPEALIASES
    typealias Sections = SearchScreenVC.Sections
    typealias Items = SearchScreenVC.Items
    
    // MARK: - VIPER
    weak var view: SearchScreenViewProtocol?
    var router: SearchScreenRouterProtocol
    var interactor: SearchScreenInteractorProtocol
    
    // MARK: - PROPERTIES
    private var searchText: String? = nil
    private var searchResults: [MediaProtocol] = []
    private var recents: [MediaProtocol] = RecentMediaHelper.getRecentMedia()
    
    // MARK: - PROPERTIES
    init(interactor: SearchScreenInteractorProtocol, router: SearchScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - PRIVATE FUNC
    private func applySnapshot() {
        let headerVM = SearchScreenHeaderCellViewModel(
            didTapSearch: { [weak self] in self?.didTapSearch($0) },
            didTapBackButton: { [weak self] in self?.router.popBack() }
        )
        
        let verticalMediaListVM: VerticalMediaListCellViewModel
        
        if searchResults.isEmpty {
            verticalMediaListVM = VerticalMediaListCellViewModel(
                media: recents, title: "Recent Media",
                subtitle: "Your recent media",
                didTapAnyMedia: { [weak self] in self?.router.pushToMedia(media: $0) }
            )
        } else {
            verticalMediaListVM = VerticalMediaListCellViewModel(
                media: searchResults, title: "Search Results",
                subtitle: "Results for \(searchText ?? "")",
                didTapAnyMedia: { [weak self] in self?.router.pushToMedia(media: $0) }
            )
        }
        let sections = [Sections.searchBar, Sections.media]
        let itemsBySection: [Sections: [Items]] = [.searchBar : [.headerCell(headerVM)], .media : [.mediaCell(verticalMediaListVM)]]
        self.view?.applySnapshot(sections: sections, itemsBySection: itemsBySection)
    }
    
    private func didTapSearch(_ query: String?) {
        guard let query = query, !query.isEmpty else {
            self.searchResults = []
            applySnapshot()
            return
        }
        self.view?.showLoadingView()
        self.searchText = query
        interactor.didSearch(searchText: query)
    }
}

extension SearchScreenPresenter: SearchScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        applySnapshot()
    }
    
    func didReceiveSearchResults(_ items: [any MediaProtocol]) {
        self.searchResults = items
        applySnapshot()
        self.view?.hideLoadingView()
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
