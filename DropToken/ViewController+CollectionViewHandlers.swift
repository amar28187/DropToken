//
//  ViewController+CollectionViewHandlers.swift
//  DropToken
//
//  Created by Amar Makana on 5/20/21.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.boardSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.boardSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        
        if let array = self.columnVisits[indexPath.section] {
            //array.reverse() // Reverse if needed
            let whoseToken = array[indexPath.row]
            switch whoseToken {
            case 1:
                cell.backgroundColor = .blue
            case 2:
                cell.backgroundColor = .red
            default:
                cell.backgroundColor = .clear
            }
        }
        
        return cell
    }
}


extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: \(indexPath.section) : \(indexPath.row) ")
        collectionView.deselectItem(at: indexPath, animated: true)
        
        var update = turns
        update.append(indexPath.section)

        GameService.play(turns: update) { nextTurns in
            guard let next = nextTurns else {
                self.showWarning()
                return
            }

            self.turns.append(indexPath.section)
            
            /// Determine and add the move from didSelect first
            if let index = self.columnVisits[indexPath.section]?.lastIndex(of: 0){
                self.columnVisits[indexPath.section]?[index] = self.whoPlayedNow()
                
                if self.whoPlayedNow() == 1 {
                    self.rowVisits[index] += 1
                } else if self.whoPlayedNow() == 2 {
                    self.rowVisits[index] -= 1
                }
                
                if index == indexPath.section {
                    if self.whoPlayedNow() == 1{
                        self.diagonalLeftToRight += 1
                    } else if self.whoPlayedNow() == 2 {
                        self.diagonalLeftToRight -= 1
                    }
                }
                
                if indexPath.section == (dotsPerColumn - index - 1){
                    if self.whoPlayedNow() == 1{
                        self.diagonalRightToLeft += 1
                    } else if self.whoPlayedNow() == 2 {
                        self.diagonalRightToLeft -= 1
                    }
                }
                
                DispatchQueue.main.sync { [weak self] in
                    self?.boardGame.reloadData()
                    if let val = self?.validateBoard(for: index, and: indexPath.section), val == true {
                        self?.showWinner()
                        return
                    }
                }
            }

            
            /// Assign new moves from service
            self.turns = next
            
            /// Determine and add the move from service
            if let last = next.last, let index = self.columnVisits[last]?.lastIndex(of: 0){
                self.columnVisits[last]?[index] = self.whoPlayedNow()
                
                
                if self.whoPlayedNow() == 1 {
                    self.rowVisits[index] += 1
                } else if self.whoPlayedNow() == 2 {
                    self.rowVisits[index] -= 1
                }
                
                if index == last {
                    if self.whoPlayedNow() == 1{
                        self.diagonalLeftToRight += 1
                    } else if self.whoPlayedNow() == 2 {
                        self.diagonalLeftToRight -= 1
                    }
                }
                
                if last == (dotsPerColumn - index - 1){
                    if self.whoPlayedNow() == 1{
                        self.diagonalRightToLeft += 1
                    } else if self.whoPlayedNow() == 2 {
                        self.diagonalRightToLeft -= 1
                    }
                }
                
                DispatchQueue.main.sync { [weak self] in
                    self?.boardGame.reloadData()
                    if let val = self?.validateBoard(for: index, and: last), val == true {
                        self?.showWinner()
                        return
                    }
                }
            }

            

        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return (self.boardGame.frame.width - CGFloat(50 * dotsPerColumn))/CGFloat(2*dotsPerColumn)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let metric = (self.boardGame.frame.width - CGFloat(50 * dotsPerColumn))/CGFloat(2*dotsPerColumn)
        
        return UIEdgeInsets(top: metric,
                            left: metric,
                            bottom: metric,
                            right: metric)
    }
}
