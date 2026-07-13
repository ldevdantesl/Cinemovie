//
//  PosterPickerVC.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 9.07.2026.
//

import UIKit

final class PosterPickerVC: UIViewController {
    
    private let media: [MediaProtocol]
    private let maxSelection = 6
    private var selectedIndexes: [Int] = []
    private let onDone: ([MediaProtocol]) -> Void
    
    private lazy var shareButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Share"
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let itemW = (UIScreen.main.bounds.width - 16 * 2 - 12 * 2) / 3
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: itemW * 1.5)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 12, left: 16, bottom: 100, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = CMColor.cmBackground
        cv.allowsMultipleSelection = true
        cv.register(PickerPosterCell.self, forCellWithReuseIdentifier: PickerPosterCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    init(media: [MediaProtocol], onDone: @escaping ([MediaProtocol]) -> Void) {
        self.media = media
        self.onDone = onDone
        super.init(nibName: nil, bundle: nil)
        selectedIndexes = Array(0..<min(maxSelection, media.count))
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pick up to 6 posters"
        view.backgroundColor = CMColor.cmBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-12)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        updateShareButton()
    }
    
    private func updateShareButton() {
        shareButton.configuration?.title = "Share (\(selectedIndexes.count))"
        shareButton.isEnabled = !selectedIndexes.isEmpty
    }
    
    @objc private func didTapShare() {
        let selected = selectedIndexes.map { media[$0] }
        dismiss(animated: true) { [onDone] in onDone(selected) }
    }
}

extension PosterPickerVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int { media.count }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: PickerPosterCell.identifier, for: indexPath) as! PickerPosterCell
        let order = selectedIndexes.firstIndex(of: indexPath.item)
        cell.configure(posterPath: media[indexPath.item].posterPath, selectionNumber: order.map { $0 + 1 })
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggle(indexPath.item)
        cv.reloadData()
    }
    
    private func toggle(_ index: Int) {
        if let pos = selectedIndexes.firstIndex(of: index) {
            selectedIndexes.remove(at: pos)
        } else {
            guard selectedIndexes.count < maxSelection else {
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                return
            }
            selectedIndexes.append(index)
        }
        updateShareButton()
    }
}
