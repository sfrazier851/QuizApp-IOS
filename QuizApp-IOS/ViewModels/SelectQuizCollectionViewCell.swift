//
//  SelectQuizCollectionViewCell.swift
//  QuizApp-IOS
//
//  Created by iMac on 3/18/22.
//

import UIKit

class SelectQuizCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var slideImageView: UIImageView!
    
    // set the image
    func configure(image: UIImage) {
        slideImageView.image = image
    }
}
