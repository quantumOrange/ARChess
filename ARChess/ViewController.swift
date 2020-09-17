//
//  ViewController.swift
//  ARChess
//
//  Created by David Crooks on 10/09/2020.
//  Copyright © 2020 David Crooks. All rights reserved.
//

import UIKit
import RealityKit
import ChessEngine

class ViewController: UIViewController {
    var chessboard:Chessboard = Chessboard.start() {
        didSet {
            print(chessboard)
            selected = nil
            positionPiecesOnBoard()
            
            hideAllSquare()
            requestMoveIfNeeded()
        }
    }
    
   
    @IBOutlet var arView: ARView!
    
    var chessAnchor: Experience.Chess!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Chess" scene from the "Experience" Reality File
        self.chessAnchor = try! Experience.loadChess()
        
        chessAnchor.actions.tapToSelect.onAction = handleTapOnChesspiece(_:)

        arView.scene.anchors.append(chessAnchor)
       
        chessAnchor.generateCollisionShapes(recursive: true)
        
        positionPiecesOnBoard()
        positionSquaresOnBoard()
        hideAllSquare()
    }
    
    var selected:(ChessboardSquare,ChessPiece)? {
        didSet {
            hideAllSquare()
            
            if let (square, piece) = selected {
                showValidDestinationSquares(for: square)
            }
        }
    }
    
    func handleTapOnChesspiece(_ entity: Entity?) {
        guard let entity = entity else { return }
        
        if let (square, piece) = chessboard.piece(for: entity) {
            switch piece.player {
            case .white:
                //select this piece
                selected =  (square, piece)
  
            case .black:
                 //trying to take a piece
                 tryToMove(to: square)
            }
        }
        else if let square = chessboard.square(for: entity) {
            tryToMove(to: square)
        }
        else {
            print("WARNING: An unidentified Entity named \(entity.name) was tapped")
        }
    }
    
    func requestMoveIfNeeded()
   {
       if chessboard.whosTurnIsItAnyway == .black
       {
           let board = chessboard
           DispatchQueue.global().async
           {
               if let move = pickMove(for: board, depth: 1) ,
                  let newBoard = apply(move: move, to: board)
                  {
                     DispatchQueue.main.async
                     {
                       self.chessboard = newBoard
                     }
                  }
           }
       }
   }
    
    func hideAllSquare() {
        chessboard
            .squares
            .compactMap{ chessAnchor.entity(for: $0)}
            .forEach{ $0.isEnabled = false }
    }
    
    func showValidDestinationSquares(for square: ChessboardSquare) {
        chessboard
            .validDestinationSquares(for: square)
            .compactMap{ chessAnchor.entity(for: $0)}
            .forEach{ $0.isEnabled = true  }
    }
    
    func tryToMove(to square:ChessboardSquare)
    {
        if let (start,_) = selected
        {
            let mv = Move(from: start, to:square)
            if let newBoard = apply(move: mv, to: chessboard)
            {
                chessboard = newBoard
            }
        }
    }
    
    func positionPiecesOnBoard()
    {
        guard let origin = chessAnchor.squareA1 else { return }
        
        chessboard
            .takenPieces
            .forEach {
                if let entity = chessAnchor.entity(for:$0)
                {
                    entity.isEnabled = false
                }
                else
                {
                    print("WARNING: no entity for \($0.identifyingName)")
                }
            }
        
        chessboard
            .positionPieces
            .forEach
            { square, piece in
                
                if let entity = chessAnchor.entity(for:piece)
                {
                    
                    let translation = Transform.init(translation: square.positionInAR )
                           
                    let animationPC = entity.move(to: translation, relativeTo: origin, duration: 0.5)
                    animationPC.resume()
                  
                }
                else
                {
                    print("WARNING: no entity for \(piece.identifyingName)")
                }
            }
    }
    
    func positionSquaresOnBoard()
    {
        print("Position squares on board")
        guard let origin = chessAnchor.squareA1 else { return }
        
        chessboard
            .squares
            .forEach
            { square in
                
                if let entity = chessAnchor.entity(for:square)
                {
                    let translation = Transform.init(translation: square.positionInAR )
                           
                    let animationPC = entity.move(to: translation, relativeTo: origin, duration: 0.5)
                    animationPC.resume()
                    
                }
                else
                {
                    print("WARNING: no entity for \(square)")
                }
            }
    }
    
}



