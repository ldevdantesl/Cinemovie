//
//  FeedbackGenerator.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 7.02.2025.
//

import Foundation
import UIKit

final class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    
    private var generators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    
    private init() {
        generators[.light] = UIImpactFeedbackGenerator(style: .light)
        generators[.medium] = UIImpactFeedbackGenerator(style: .medium)
        generators[.heavy] = UIImpactFeedbackGenerator(style: .heavy)
        
        generators.values.forEach { $0.prepare() }
    }
    
    func generate(
        with style: UIImpactFeedbackGenerator.FeedbackStyle = .medium,
        intensity: CGFloat? = nil
    ) {
        if let generator = generators[style] {
            generator.prepare()
    
            if let intensity = intensity {
                generator.impactOccurred(intensity: intensity)
            } else {
                generator.impactOccurred()
            }
            
            generator.prepare()
        }
    }
}
