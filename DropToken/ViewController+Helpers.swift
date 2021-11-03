//
//  ViewController+Helpers.swift
//  DropToken
//
//  Created by Amar Makana on 5/20/21.
//

import Foundation
import UIKit

extension ViewController {
    
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    //MARK:- Game initializations
    func resetVisits() {
        for i in 0..<dotsPerColumn {
            self.columnVisits[i] = Array(repeating: 0, count: dotsPerColumn)
        }
        for i in 0..<dotsPerColumn {
            self.rowVisits_Test[i] = Array(repeating: 0, count: dotsPerColumn)
        }
        self.diagonalRightToLeft = 0
        self.diagonalLeftToRight = 0
        self.rowVisits = Array(repeating: 0, count: dotsPerColumn)
    }
    
    //MARK:- Requirement 1 - The app must allow the player to choose whether they want to go first, or if they want our service to go first.
    func gameSetup() {
        self.boardSize = 0
        self.whoseTurn.isHidden = true
        self.whoPlaysFirstLabel.isHidden = false
        self.noButton.isHidden = false
        self.yesButton.isHidden = false
        self.startNewGame.isHidden = true
        self.turns = []
        self.whoPlaysFirstLabel.text = "Want to play first?"
        self.resetVisits()
        self.boardGame.reloadData()
    }
    
    func startGame() {
        self.boardSize = dotsPerColumn
        self.whoPlaysFirstLabel.isHidden = true
        self.whoseTurn.isHidden = false
        UIView.animate(withDuration: 1) {
            self.whoseTurn.text = "Initializing..."
        }

        self.turns = []
        self.resetVisits()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            
            //Show who decided to go first
            self?.whoseTurn.text = "Player " + (self?.serviceFirst ?? false ? "2" : "1") + " turn"
            
            self?.boardGame.reloadData()
        }
    }
    
    // MARK:- Validations    
    @discardableResult
    func validateBoard(for row: Int, and column: Int) -> Bool{
        var winnerFound = false
        
        //MARK:- Requirement 2
        /// If there is a win on either side, the app must display who won and let the player play again.
        
        // Check verticals
        winnerFound = self.checkVerticals(column: column)
        if winnerFound{
            return winnerFound
        }
        
        // Check horizontals
        winnerFound = self.checkHorizontals(row: row)
        if winnerFound{
            return winnerFound
        }
        
        // Check diagonals
        winnerFound = self.checkDiagonals(row: row, column: column)
        if winnerFound{
            return winnerFound
        }
        
        //MARK:- Requirement 3
        /// If the board is full, the app must tell the user the game is a draw and let the player play again.
        if isBoardFull{
            print("Play new game")
            self.showAlert(withMessage: "Board full")
        }
        
        print("calling Validate")
        return winnerFound
    }
    
    func checkVerticals(column: Int) -> Bool {
        if let arr = columnVisits[column] {
            if arr.filter({$0 == 2}).count == dotsPerColumn || arr.filter({$0 == 1}).count == dotsPerColumn {
                self.showAlert(withMessage: "Player \(self.serviceFirst ? "2" : "1") is the winner")
                print("Final scores:\n \(self.columnVisits)")
                return true
            }
        }
        
        return false
    }
    
    func checkHorizontals(row: Int) -> Bool {
        print("rowVisits: \(rowVisits)")
        let element = rowVisits[row]
        
        if element == dotsPerColumn {
            return true
        } else if element == -dotsPerColumn {
            return true
        }

        return false
    }
    
    func checkDiagonals(row: Int, column: Int) -> Bool {
        if row == column{
            if whoPlayedNow() == 1{
                 return diagonalLeftToRight == dotsPerColumn
            } else {
                return diagonalLeftToRight == -dotsPerColumn
            }
        }
        
        if column ==  dotsPerColumn -  row - 1 {
            if whoPlayedNow() == 1{
                 return diagonalRightToLeft == dotsPerColumn
            } else {
                return diagonalRightToLeft == -dotsPerColumn
            }
        }
        
        
        print("diagonalLeftToRight: \(diagonalLeftToRight)")
        print("\n\n")
        print("diagonalRightToLeft: \(diagonalRightToLeft)")
        
        return false

    }
    
    // MARK:- Alerts
    func showWarning() {
        let alert = UIAlertController(title: "OOPS!", message: "Invalid move, select a valid column", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Dismiss", style: .destructive)
        alert.addAction(action)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Game over!", message: message, preferredStyle: UIAlertController.Style.alert)
        
        /// Actions
        let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
        let okAction = UIAlertAction(title: "Play again?", style: .default) { [weak self] action in
            self?.gameSetup()
        }
        
        /// Add actions
        alert.addAction(okAction)
        alert.addAction(dismissAction)
        
        DispatchQueue.main.async { [weak self] in
            /// Present alert
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showWinner() {
        self.showAlert(withMessage: "Player \(self.whoPlayedNow()) is the winner")
        print("Final scores:\n \(self.columnVisits)")
    }

    // MARK:- Helper functions
    func whoPlayedNow() -> Int {
        var returnValue = 0
        
        if self.serviceFirst{
            if (self.turns.count % 2 == 0) {
                returnValue = 2
            } else {
                returnValue = 1
            }
        } else{
            if (self.turns.count % 2 == 0) {
                returnValue = 2
            } else {
                returnValue = 1
            }
        }
        
        print("Player \(returnValue) played")
        print("Turns: \(turns)")
        
        return returnValue
    }
}
