//
//  GameSettings.swift
//  Cards
//
//  Created by Давид Тоноян  on 11.08.2022.
//

import Foundation

protocol GameSettingsProtocol {
    var cardsPairs: Int { get set }
}

class GameSettings: GameSettingsProtocol {
    var cardsPairs: Int = 8
}

protocol GameSettingsStorageProtocol {
    func loadSettings() -> GameSettingsProtocol
    func saveSettings(_ settings: GameSettingsProtocol)
}

class GameSettingsStorage: GameSettingsStorageProtocol {
    private var storage = UserDefaults.standard
    private enum StorageKey: String {
        case cardsPairs
    }
    
    func loadSettings() -> GameSettingsProtocol {
        let settings = GameSettings()
        let cardsPairs = storage.integer(forKey: StorageKey.cardsPairs.rawValue)
        settings.cardsPairs = cardsPairs
        return settings
    }
    
    func saveSettings(_ settings: GameSettingsProtocol) {
        let cardPairsForStorage = settings.cardsPairs
        storage.set(cardPairsForStorage, forKey: StorageKey.cardsPairs.rawValue)
    }
}
