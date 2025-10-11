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
    
    // MARK: - PROPERTIES
    var visibleSections: [SearchScreenVC.Sections] { get set }
    
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
    var visibleSections: [SearchScreenVC.Sections] = []
    
    // MARK: - PROPERTIES

    init(interactor: SearchScreenInteractorProtocol, router: SearchScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension SearchScreenPresenter: SearchScreenPresenterProtocol {
    // MARK: - STARTING
    func viewDidLoaded() {
        let headerVM = SearchScreenHeaderCellViewModel(didTapSearch: nil, didTapBackButton: router.popBack)
        let recents = RecentMediaHelper.getRecentMedia()
        let verticalMediaListVM = VerticalMediaListCellViewModel(
            media: recents, title: "Recent Media",
            subtitle: "Your recent media",
            didTapAnyMedia: router.pushToMedia
        )
        let sections = [Sections.searchBar, Sections.media]
        let itemsBySection: [Sections: [Items]] = [.searchBar : [.headerCell(headerVM)], .media : [.mediaCell(verticalMediaListVM)]]
        self.visibleSections = sections
        self.view?.applySnapshot(sections: sections, itemsBySection: itemsBySection)
    }
    
    // MARK: - ERROR
    func didRecieveError(_ error: Error) {
        view?.didRecieveError(error.localizedDescription)
    }
}
