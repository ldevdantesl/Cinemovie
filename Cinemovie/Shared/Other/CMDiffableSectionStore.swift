//
//  CMSectionStore.swift
//  Cinemovie
//
//  Created by Buzurg Rakhimzoda on 30.03.2026.
//

import Foundation

final class CMDiffableSectionStore<Section: Hashable> {
    private var sections: [Section] = []
    
    func update(_ newSections: [Section]) {
        sections = newSections
    }
    
    func section(at index: Int) -> Section? {
        guard index >= 0 && index < sections.count else { return nil }
        return sections[index]
    }
    
    deinit { }
}
