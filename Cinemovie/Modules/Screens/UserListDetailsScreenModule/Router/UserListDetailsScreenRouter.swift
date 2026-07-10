//
//  UserListDetailsScreenRouter.swift
//  Super easy dev
//
//  Created by Buzurg Rakhimzoda on 14.05.2025
//

import UIKit

protocol UserListDetailsScreenRouterProtocol {
    func goBack()
    
    func presentShareSheet(items: [Any])
    func presentPosterPicker(media: [MediaProtocol], onDone: @escaping ([MediaProtocol]) -> Void)
    func navigateToMovie(movie: Movie)
    func navigateToSeries(series: TVSeries)
}

final class UserListDetailsScreenRouter: UserListDetailsScreenRouterProtocol {
    weak var viewController: UserListDetailsScreenVC?
    private let diContainer: DIContainer
    
    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func presentShareSheet(items: [Any]) {
        guard let viewController else { return }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        viewController.present(activityVC, animated: true)
    }
    
    func presentPosterPicker(media: [MediaProtocol], onDone: @escaping ([MediaProtocol]) -> Void) {
        let picker = PosterPickerVC(media: media, onDone: onDone)
        let nav = UINavigationController(rootViewController: picker)
        nav.sheetPresentationController?.detents = [.large()]
        viewController?.present(nav, animated: true)
    }
    
    func navigateToMovie(movie: Movie) {
        let vc = MovieDetailsScreenAssembler.assemble(movieID: movie.id, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToSeries(series: TVSeries) {
        let vc = TVSeriesDetailsScreenAssembler.assemble(seriesID: series.id, diContainer: diContainer)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
