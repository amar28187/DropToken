//
//  ViewController.swift
//  DropToken
//
//  Created by Amar Makana on 5/19/21.
//

import UIKit
var dotsPerColumn: Int = 4

class ViewController: UIViewController {

    @IBOutlet weak var startNewGame: UIButton!
    @IBOutlet weak var whoPlaysFirstLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var whoseTurn: UILabel!
    @IBOutlet weak var boardGame: UICollectionView!
    
    var turns: Turns = [Int]()
    var rowVisits_Test = [Int : [Int]]()
    
    var columnVisits = [Int : [Int]]()
    var rowVisits = [Int]()
    var diagonalLeftToRight: Int = 0
    var diagonalRightToLeft: Int = 0
    var serviceFirst: Bool = false
    var isBoardFull: Bool {
        get{
            return turns.count >= 16
        }
    }
    
    var boardSize: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        self.gameSetup()        
        
    }
    
    @IBAction func startNewGame(_ sender: Any) {
        self.gameSetup()
    }
    
    @IBAction func clickedYES(_ sender: Any) {
        self.serviceFirst = false
        self.whoPlaysFirstLabel.text = "You are - Player " +  (serviceFirst ? "2" : "1")
        self.noButton.isHidden = true
        self.yesButton.isHidden = true
        self.startNewGame.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startGame()
        }
        
    }
    
    @IBAction func clickedNO(_ sender: Any) {
        self.serviceFirst = true
        self.whoPlaysFirstLabel.text = "You are - Player " +  (serviceFirst ? "2" : "1")
        self.noButton.isHidden = true
        self.yesButton.isHidden = true
        self.startNewGame.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.startGame()
            
            GameService.play(turns: self?.turns ?? []) { nextTurns in
                DispatchQueue.main.async {
                    guard let next = nextTurns else {
                        self?.showWarning()
                        return
                    }
                    if let i = next.first, let index = self?.columnVisits[i]?.lastIndex(of: 0) {
                        self?.columnVisits[i]?[index] = 1
                    }
                    self?.turns = next
                    self?.boardGame.reloadData()
                }
            }
        }
        
    }
}
