//
//  Experince.Chess+ChessEngine.swift
//  ARChess
//
//  Created by David Crooks on 11/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine
import RealityKit

let squareSide:Float = 0.05
let boardHeight:Float = 0.025

extension Experience.Chess {
    
    func entity(for piece:ChessPiece)-> Entity? {
        findEntity(named: piece.identifyingName)
    }
    
    func entity(for square:ChessboardSquare)-> Entity? {
        return findEntity(named: "square \(square)")
    }
}

