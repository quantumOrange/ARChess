//
//  Chessboard+Experience.swift
//  ARChess
//
//  Created by David Crooks on 11/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine
import RealityKit

extension Chessboard {
    func piece(for entity:Entity) -> (ChessboardSquare,ChessPiece)? {
         positionPieces.first(where: {
            let (_,piece) = $0
            return piece.identifyingName == entity.name
        })
    }
    
    func square(for entity:Entity) -> ChessboardSquare? {
        if !entity.name.contains("square") { return nil }
        let squareName = String(entity.name.suffix(2))
        return ChessboardSquare(code: squareName)
    }
    
    func validDestinationSquares(for selected: ChessboardSquare) -> [ ChessboardSquare] {
           return validMoves(chessboard: self, square:selected, includeCastles: true)
                                .compactMap{ ChessboardSquare(rawValue: $0.to) }
    }
}



