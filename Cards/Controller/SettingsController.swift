//
//  SettingsController.swift
//  Cards
//
//  Created by Давид Тоноян  on 11.08.2022.
//

import UIKit

class SettingsController: UIViewController {
    private var cardsPairs: Int = 0
    lazy var cardsLabel = getCardsLabel()
    lazy var saveButton = getSaveButton()
    lazy var cardsNumSlider = getCardsSlider()
    let storage: GameSettingsStorageProtocol = GameSettingsStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(cardsLabel)
        view.addSubview(cardsNumSlider)
        view.addSubview(saveButton)
    }
    
    private func getCardsLabel() -> UILabel {
        let label = UILabel(frame: CGRect(x: 50, y: 50, width: 200, height: 40))
        label.text = "Enter cards number: "
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        return label
    }
    
    private func getCardsSlider() -> UISlider {
        let slider = UISlider(frame: CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 50))
        slider.maximumValue = 20
        slider.minimumValue = 0
        slider.addTarget(nil, action: #selector(sliderChanged), for: .valueChanged)
        return slider
    }
    
    private func getSaveButton() -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center.x = view.center.x
        button.center.y = view.frame.height - 150
        
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(saveSettings), for: .touchUpInside)
        return button
    }
    
    @objc func sliderChanged(_ sender: UISlider) {
        cardsPairs = Int(sender.value.rounded())
        cardsLabel.text = "Enter cards number: \(cardsPairs)"
    }

    @objc func saveSettings(_ sender: UIButton) {
        var settings: GameSettingsProtocol = GameSettings()
        settings.cardsPairs = cardsPairs
        storage.saveSettings(settings)
        dismiss(animated: true)
    }
}
