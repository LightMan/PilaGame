//
//  ViewController.swift
//  Pila
//
//  Created by Dev2 on 24/04/2019.
//  Copyright © 2019 Dev2. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var txtfUser: UITextField!
    @IBOutlet weak var stackViewGameItems: UIStackView!
    
    //    let beater = GameBeater(itemFactory: factory)
    let factory = ExerciseFactory.shared
    let beater = GameBeater(itemFactory: ExerciseFactory.shared)
    
    var stack = Stack<GameItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        txtfUser.becomeFirstResponder()
        
        stack.delegate = self
        
        beater.delegate = self
        beater.startWorking()
        
        (1...3).forEach { (_) in
            addItemToGame(factory.generateRandom())
        }
    }
    
    func checkUserText() {
        guard let userText = txtfUser.text,
            !userText.isEmpty else {
            return
        }
        
        if let topItem = stack.head {

            let correct = topItem.isCorrect(text: userText)
            if correct {
                // Texto coincide, quito plato
                removeItemFromGame()
                checkWin()
            } else {
                addItemToGame(userText)
                checkLose()
            }
        } else {
            debugPrint("Aquí no debería de llegar")
        }
        
        txtfUser.text = ""
    }
    
    func removeItemFromGame() {
        if let view = stackViewGameItems.arrangedSubviews.first {
            view.removeFromSuperview()
        }
        stack.pop()
    }
    
    func addItemToGame(_ item: GameItem) {
        // Texto no coincide, castigo al usuario añadiendo su texto como plato
        let itemLabel = UILabel()
        itemLabel.text = item.textPresentation
        itemLabel.textAlignment = .center
        stackViewGameItems.insertArrangedSubview(itemLabel, at: 0) // Arriba
        stack.push(item: item)
    }
    
    func checkLose() {
        if stack.count < 15 {
            return
        }
        
        // He perdido
        view.backgroundColor = UIColor.red
        txtfUser.resignFirstResponder()
        beater.stopWorking()
    }
    
    func checkWin() {
        if stack.count > 0 {
            return
        }
        // He ganado
        view.backgroundColor = UIColor.green
        txtfUser.resignFirstResponder()
        beater.stopWorking()
    }
    
    @IBAction func btnSolvePressed(_ sender: Any) {
        checkUserText()
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkUserText()
        return false
    }
}
    
extension MainViewController: GameBeaterDelegate {
    
    func beater(_ beater: GameBeater, hasNewGameItem item: GameItem) {
        addItemToGame(item)
        checkLose()
    }
}

extension MainViewController: StackDelegate {
    func stack<Item>(_ stack: Stack<Item>, pushedItem item: Item) {
        debugPrint("Se ha añadido \(item)")
    }
    
    func stack<Item>(_ stack: Stack<Item>, popedItem item: Item) {
        debugPrint("Se ha quitado \(item)")
    }

}
