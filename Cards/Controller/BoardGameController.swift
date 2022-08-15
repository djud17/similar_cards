//
//  BoardGameController.swift
//  Cards
//
//  Created by Давид Тоноян  on 09.08.2022.
//

import UIKit

class BoardGameController: UIViewController {
    private let storage: GameSettingsStorageProtocol = GameSettingsStorage()
    private var cardsPairsCount: Int {
        storage.loadSettings().cardsPairs
    }
    lazy var game: Game = getNewGame()
    lazy var startButton = getStartButton()
    lazy var boardGameView = getBoardGameView()
    lazy var flipAllCardsButton = getFlipAllCardsButton()
    lazy var scoreLabel = getScoreLabel()
    
    private var cardSize: CGSize {
        CGSize(width: 80, height: 120)
    }
    private var cardMaxXCoordinate: Int {
        Int(boardGameView.frame.width - cardSize.width)
    }
    private var cardMaxYCoordinate: Int {
        Int(boardGameView.frame.height - cardSize.height)
    }
    var cardViews = [UIView]()
    private var flippedCards = [UIView]()
    private var flipScore: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.flipScore)"
        }
    }
    private var cardsCount: Int = 0 {
        didSet {
            if cardsCount == 0 {
                gameOver()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(startButton)
        view.addSubview(boardGameView)
        view.addSubview(flipAllCardsButton)
        view.addSubview(scoreLabel)
    }
    
    private func getNewGame() -> Game {
        let game = Game()
        game.cardsCount = self.cardsPairsCount
        game.generateCards()
        return game
    }
    
    private func getStartButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 10, y: 0, width: 140, height: 50))
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        button.frame.origin.y = topPadding
        
        button.setTitle("Start Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(startGame), for: .touchUpInside)
        return button
    }
    
    private func getFlipAllCardsButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: view.frame.width - 150, y: 0, width: 140, height: 50))
        button.center.y = startButton.center.y
        button.setTitle("Flip all cards", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.setTitleColor(.gray, for: .disabled)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(flipAllCards), for: .touchUpInside)
        button.isEnabled = false
        return button
    }
    
    @objc func flipAllCards(_ sender: UIButton) {
        var flippy: Bool
        let flippedCount = cardViews.filter{($0 as! FlippableView).isFlipped }.count
        
        flippy = !(flippedCount >= cardViews.count - 1)
        cardViews.forEach {
            ($0 as? FlippableView)?.isFlipped = flippy
        }
        flippedCards.removeAll()
    }
    
    @objc func startGame(_ sender: UIButton) {
        flipAllCardsButton.isEnabled = true
        game = getNewGame()
        let cards = getCardsBy(modelData: game.cards)
        placeCardsOnBoard(cards)
        flipScore = 0
        cardsCount = cardViews.count
    }
    
    private func getBoardGameView() -> UIView {
        let margin: CGFloat = 10
        let boardView = UIView()
        
        boardView.frame.origin.x = margin
        
        let window = UIApplication.shared.windows[0]
        let topPadding = window.safeAreaInsets.top
        boardView.frame.origin.y = topPadding + startButton.frame.height + margin
        
        boardView.frame.size.width = UIScreen.main.bounds.width - margin * 2
        
        let bottomPadding = window.safeAreaInsets.bottom
        boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
        
        boardView.layer.cornerRadius = 5
        boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
        
        return boardView
    }
    
    private func getScoreLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        label.center.x = view.center.x
        label.center.y = startButton.center.y
        label.text = "Score: 0"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }
    
    private func getCardsBy(modelData: [Card]) -> [UIView] {
        var cardViews = [UIView]()
        let cardViewFactory = CardViewFactory()
        
        for (index, modelCard) in modelData.enumerated() {
            let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardOne.tag = index
            cardViews.append(cardOne)
            
            let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
            cardTwo.tag = index
            cardViews.append(cardTwo)
        }
        
        for card in cardViews {
            (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
                flippedCard.superview?.bringSubviewToFront(flippedCard)
                
                if flippedCard.isFlipped {
                    flipScore += 1
                    self.flippedCards.append(flippedCard)
                } else {
                    if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
                        self.flippedCards.remove(at: cardIndex)
                    }
                }
                
                if self.flippedCards.count == 2 {
                    let firstCard = game.cards[self.flippedCards.first!.tag]
                    let secondCard = game.cards[self.flippedCards.last!.tag]
                    
                    if game.checkCards(firstCard, secondCard) {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.flippedCards.first!.layer.opacity = 0
                            self.flippedCards.last!.layer.opacity = 0
                        }, completion: { _ in
                            self.cardsCount -= 2
                            self.flippedCards.first!.removeFromSuperview()
                            self.flippedCards.last!.removeFromSuperview()
                            self.flippedCards = []
                        })
                    } else {
                        for card in self.flippedCards {
                            (card as? FlippableView)?.flip()
                        }
                    }
                }
            }
        }
        
        return cardViews
    }
    
    private func placeCardsOnBoard(_ cards: [UIView]) {
        for card in cardViews {
            card.removeFromSuperview()
        }
        
        cardViews = cards
        for card in cardViews {
            let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
            let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
            card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
            boardGameView.addSubview(card)
        }
    }
    
    private func gameOver() {
        let alert = UIAlertController(title: "Game over!", message: "To find \(cardViews.count / 2) card pairs, you use \(flipScore) flips.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
