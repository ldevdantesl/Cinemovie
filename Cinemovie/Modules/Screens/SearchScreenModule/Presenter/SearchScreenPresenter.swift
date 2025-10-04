//
//  SearchScreenPresenter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 13.06.2025
//

protocol SearchScreenPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func viewWillAppear()
}

final class SearchScreenPresenter {
    weak var view: SearchScreenViewProtocol?
    var router: SearchScreenRouterProtocol
    var interactor: SearchScreenInteractorProtocol

    init(interactor: SearchScreenInteractorProtocol, router: SearchScreenRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

extension SearchScreenPresenter: SearchScreenPresenterProtocol {
    func viewDidLoaded() {
        
    }
    
    func viewWillAppear() {
        let headerVM = SearchScreenHeaderCellViewModel(didTapSearch: nil)
        let sections = [SearchScreenVC.Sections.main]
        let itemsBySection: [SearchScreenVC.Sections: [SearchScreenVC.Items]] = [.main : [.headerCell(headerVM)]]
        self.view?.applySnapshot(sections: sections, itemsBySection: itemsBySection)
    }
}
