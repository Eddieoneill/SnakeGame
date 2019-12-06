//
//  ViewController.swift
//  CompleteSnakeA.I
//
//  Created by Edward O'Neill on 12/5/19.
//  Copyright © 2019 Edward O'Neill. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cellCollection = [CustomCell]()
    var count = 0
    var gameTimer: Timer?
    var snakeArr = [CustomCell]()
    var snakeTagNumber: Set<Int> = []
    var randomMovement = [1, -1, 17, -17]
    var rightEdgeNumbers: Set<Int> = [17, 34, 51, 68, 85, 102, 119, 136, 153, 170, 187, 204, 221, 238, 255, 272, 289]
    var leftEdgeNumber: Set<Int> = [18, 35, 52, 69, 86, 103, 120, 137, 154, 171, 188, 205, 222, 239, 256, 273, 290]
    var topRowNumber: Set<Int> =  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]
    var bottomRowNumber: Set<Int> = [289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5
        layout.minimumInteritemSpacing = 0.5
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let button: UIButton = {
        let frame = CGRect(x: 150, y: 500, width: 100, height: 50)
        let button = UIButton(type: .system)
        button.frame = frame
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    @objc func startGame(sender : UIButton) {
        //cellCollection = cellCollection.sorted(by: { $0.tag > $1.tag })
        if button.titleLabel?.text == "Start" {
            for _ in 0...20 {
                cellCollection.randomElement()?.backgroundColor = .red
            }
            let startingPoint = cellCollection.randomElement()!
            startingPoint.backgroundColor = .green
            snakeArr.append(startingPoint)
            snakeTagNumber.insert(startingPoint.tag)
            count = 0
            button.setTitle("Reset", for: .normal)
            gameTimer = Timer.scheduledTimer(timeInterval: 0.0050, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
        } else {
            for pixel in cellCollection {
                pixel.backgroundColor = .black
            }
            snakeTagNumber = []
            snakeArr = []
            
            button.setTitle("Start", for: .normal)
            gameTimer?.invalidate()
        }
        
    }
    
    @objc func onTimerFires() {
        moveSnake()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 20).isActive = true
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 19, height: 19)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 306
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        //        cell.data = self.data[indexPath.row]
        cell.backgroundColor = .black
        cell.tag = count
        cellCollection.append(cell)
        count += 1
        
        return cell
    }
}

// MARK: movement for the snake
extension ViewController {
    func moveSnake() {
        var movablePixel = false
        var movingDirection = 0
        
        while movablePixel == false {
            movingDirection = randomMovement.randomElement()!
            if containsInTheDict(movementNumber: movingDirection, tagNumber: snakeArr.last!.tag){
                movablePixel = true
            }
        }
        
        for (index, pixel) in snakeArr.enumerated() {
            print((pixel.tag) + (movingDirection))
            if cellCollection[(pixel.tag) + (movingDirection)].backgroundColor == .red && pixel == snakeArr.last! {
                cellCollection[(pixel.tag) + (movingDirection)].backgroundColor = .green
                snakeArr.append(cellCollection[(pixel.tag) + (movingDirection)])
                snakeTagNumber.insert(cellCollection[(pixel.tag) + (movingDirection)].tag)
            } else if index == 0 && snakeArr.count > 1 {
                snakeArr[index].backgroundColor = .black
                snakeArr[index] = snakeArr[index + 1]
                snakeArr[index].backgroundColor = .green
            } else if pixel != snakeArr.last {
                snakeArr[index] = snakeArr[index + 1]
                snakeArr[index].backgroundColor = .green
            } else if snakeArr.count == 1 {
                snakeArr[index].backgroundColor = .black
                snakeArr[index] = cellCollection[(pixel.tag) + (movingDirection)]
                snakeArr[index].backgroundColor = .green
            } else {
                snakeArr[index] = cellCollection[(pixel.tag) + (movingDirection)]
                snakeArr[index].backgroundColor = .green
            }
        }
    }
    
    func containsInTheDict(movementNumber: Int, tagNumber: Int) -> Bool {
        let number = movementNumber + tagNumber
        
        if !((movementNumber == 1 && rightEdgeNumbers.contains(number)) || (movementNumber == -1 && leftEdgeNumber.contains(number)) || (snakeTagNumber.contains(number)) || (topRowNumber.contains(number) && movementNumber == -17) || (bottomRowNumber.contains(number) && movementNumber == 17) || (movementNumber == 1 && tagNumber == 305) || (movementNumber == -1 && tagNumber == 0)) {
            return true
        }
        
        return false
    }
}


/*
 [ 1,   2,   3,   4,   5,   6,   7,   8,   9,   10,  11,  12,  13,  14,  15,  16,  17]
 [ 18,  19,  20,  21,  22,  23,  24,  25,  26,  17,  28,  29,  30,  31,  32,  33,  34]
 [ 35,  36,  37,  38,  39,  40,  41,  42,  43,  34,  45,  46,  47,  48,  49,  50,  51]
 [ 52,  53,  54,  55,  56,  57,  58,  59,  60,  51,  62,  63,  64,  65,  66,  67,  68]
 [ 69,  70,  71,  72,  73,  74,  75,  76,  77,  68,  79,  80,  81,  82,  83,  84,  85]
 [ 86,  87,  88,  89,  90,  91,  92,  93,  94,  85,  96,  97,  98,  99, 100, 101, 102]
 [103, 104, 105, 106, 107, 108, 109, 110, 111, 102, 113, 114, 115, 116, 117, 118, 119]
 [120, 121, 122, 123, 124, 125, 126, 127, 128, 119, 130, 131, 132, 133, 134, 135, 136]
 [137, 138, 139, 140, 141, 142, 143, 144, 145, 136, 147, 148, 149, 150, 151, 152, 153]
 [154, 155, 156, 157, 158, 159, 160, 161, 162, 153, 164, 165, 166, 167, 168, 169, 170]
 [171, 172, 173, 174, 175, 176, 177, 178, 179, 170, 181, 182, 183, 184, 185, 186, 187]
 [188, 189, 190, 191, 192, 193, 194, 195, 196, 187, 198, 199, 200, 201, 202, 203, 204]
 [205, 206, 207, 208, 209, 210, 211, 212, 213, 204, 215, 216, 217, 218, 219, 220, 221]
 [222, 223, 224, 225, 226, 227, 228, 229, 230, 221, 232, 233, 234, 235, 236, 237, 238]
 [239, 240, 241, 242, 243, 244, 245, 246, 247, 238, 249, 250, 251, 252, 253, 254, 255]
 [256, 257, 258, 259, 260, 261, 262, 263, 264, 255, 266, 267, 268, 269, 270, 271, 272]
 [273, 274, 275, 276, 277, 278, 279, 280, 281, 272, 283, 284, 285, 286, 287, 288, 289]
 [290, 291, 292, 293, 294, 295, 296, 297, 298, 289, 300, 301, 302, 303, 304, 305, 306]
 */
