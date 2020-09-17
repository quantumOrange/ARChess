//
//  ChessboardSquare+Experience.Chess.swift
//  ARChess
//
//  Created by David Crooks on 11/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import Foundation
import ChessEngine

extension ChessboardSquare {
    var positionInAR:SIMD3<Float> {
        let x = Float( (file.rawValue))
        let z = Float( -rank.rawValue)
        return SIMD3<Float>(x*squareSide,0.0,z*squareSide)
    }
}

