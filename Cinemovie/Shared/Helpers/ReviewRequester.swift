//
//  ReviewRequester.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 7.07.2026.
//

import Foundation
import UIKit
import StoreKit

final class CMReviewRequester {
    
    enum SignificantEvent {
        case openedMovie
        case createdList
        case openedFeatured
        
        var threshold: Int {
            switch self {
            case .openedMovie, .openedFeatured: return 5
            case .createdList: return 2
            }
        }
    }
    
    static let shared = CMReviewRequester()
    private init() {}

    private let lastRequestVersionKey: String = "lastRequestVersion"

    private func countKey(for event: SignificantEvent) -> String {
        "reviewEventCount_\(event)"
    }

    private var lastRequestVersion: String? {
        get { CMStorage.load(String.self, key: lastRequestVersionKey) }
        set { CMStorage.save(newValue, key: lastRequestVersionKey) }
    }

    private func count(for event: SignificantEvent) -> Int {
        CMStorage.load(Int.self, key: countKey(for: event)) ?? 0
    }

    private func incrementCount(for event: SignificantEvent) -> Int {
        let newCount = count(for: event) + 1
        CMStorage.save(newCount, key: countKey(for: event))
        return newCount
    }

    func log(_ event: SignificantEvent) {
        let newCount = incrementCount(for: event)
        requestReviewIfAppropriate(event: event, count: newCount)
    }

    private func requestReviewIfAppropriate(event: SignificantEvent, count: Int) {
        let threshold = event.threshold
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        guard count >= threshold, currentVersion != lastRequestVersion else { return }

        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }

        if #available(iOS 16, *) {
            Task { @MainActor in
                AppStore.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }

        lastRequestVersion = currentVersion
    }
}
