//
//  NumbersCollectionViewCell.swift
//  TestProjectForXDSoft
//
//  Created by Anna Buzhinskaya on 06.07.2022.
//

import UIKit

class NumbersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    
    func configure(number: Int) {
        self.numberLabel.text = String(number)
    }
}
