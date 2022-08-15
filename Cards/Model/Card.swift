//
//  Card.swift
//  Cards
//
//  Created by Давид Тоноян  on 09.08.2022.
//

import UIKit

enum CardType: String, CaseIterable {
    case circle
    case cross
    case square
    case fill
    case clearCircle
}

enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

typealias Card = (type: CardType, color: CardColor)
