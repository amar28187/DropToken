//
//  ViewController+TestsHelpers.swift
//  DropToken
//
//  Created by Amar Makana on 6/3/21.
//

import Foundation

extension ViewController {
    
    //MARK: Test helpers
    func simulatePlays(for turns: Turns) {
        boardSize = dotsPerColumn
        for i in 0..<turns.count {
            if let index = self.columnVisits[turns[i]]?.lastIndex(of: 0){
                
                let evenOrOdd = (i % 2 == 0) ? 1 : 2 // Assuming even is player 1, odd is player 2
                
                self.columnVisits[turns[i]]?[index] = evenOrOdd
                self.rowVisits_Test[index]?[turns[i]] = evenOrOdd
                
                if index == turns[i] {
                    if (i%2 == 0){
                        diagonalLeftToRight += 1
                    } else{
                        diagonalLeftToRight -= 1
                    }
                }
                
                if turns[i] == dotsPerColumn - index - 1 {
                    if (i%2 == 0){
                        diagonalRightToLeft += 1
                    } else{
                        diagonalRightToLeft -= 1
                    }
                }
            }
        }
    }
    
    //MARK:- Test Validations
    func validateBoardForTests() -> Bool{
        var winnerFound = false

        // Check verticals
        winnerFound = self.checkVerts()
        if winnerFound{
            return winnerFound
        }
        
        // Check horizontals
        winnerFound = self.checkHorizs()
        if winnerFound{
            return winnerFound
        }
        
        // Check diagonals
        winnerFound = self.checkDiags()
        if winnerFound{
            return winnerFound
        }

        return winnerFound
    }
    
    func checkVerts() -> Bool {
        for i in 0..<dotsPerColumn {
            if let arr = columnVisits[i]{
                if arr.filter({$0 == 2}).count == dotsPerColumn || arr.filter({$0 == 1}).count == dotsPerColumn{
                    return true
                }
            }
        }
        
        return false
    }
    
    func checkHorizs() -> Bool {
        for i in 0..<dotsPerColumn {
            if let arr = rowVisits_Test[i]{
                if arr.filter({$0 == 2}).count == dotsPerColumn || arr.filter({$0 == 1}).count == dotsPerColumn{
                    return true
                }
            }
        }
        
        return false
    }
    
    func checkDiags() -> Bool {
        var winnerFound = false
        
        if diagonalRightToLeft == dotsPerColumn || diagonalRightToLeft == -dotsPerColumn {
            winnerFound = true
        } else if diagonalLeftToRight == dotsPerColumn || diagonalLeftToRight == -dotsPerColumn {
            winnerFound = true
        }
        
        print(diagonalRightToLeft)
        print(diagonalLeftToRight)
        
        return winnerFound
    }
}
