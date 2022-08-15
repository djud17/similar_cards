//
//  LaunchScreenViewController.swift
//  Cards
//
//  Created by Давид Тоноян  on 11.08.2022.
//

import UIKit

class LaunchScreenController: UIViewController {
    lazy var startGameButton = getStartGameButton()
    lazy var gameSettingsButton = getSettingsButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(startGameButton)
        view.addSubview(gameSettingsButton)
    }
    
    private func getStartGameButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center.x = view.center.x
        button.center.y = view.center.y - 35
        
        button.setTitle("New Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(startNewGame), for: .touchUpInside)
        return button
    }
    
    @objc func startNewGame(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "boardGame")
        
        present(vc, animated: true)
    }
    
    private func getSettingsButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center.x = view.center.x
        button.center.y = view.center.y + 35
        
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(openSettings), for: .touchUpInside)
        return button
    }
    
    @objc func openSettings(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "settings")
        
        present(vc, animated: true)
    }
}
