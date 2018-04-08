//
//  ExerciseViewCellTableViewCell.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

class ExerciseViewCell: UICollectionViewCell, NibLoadableView {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var repsImage: UIImageView!
    @IBOutlet weak var weightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        repsImage.image = PisteAsset.reps.image.withRenderingMode(.alwaysTemplate)
        repsImage.tintColor = UIColor.pisteRed
        weightImage.image = PisteAsset.weight.image.withRenderingMode(.alwaysTemplate)
        weightImage.tintColor = UIColor.pisteRed
    }
    
    func configure(_ viewModel: ExerciseCellViewModel) {
        label.text = viewModel.name
        repsLabel.text = viewModel.reps
        weightLabel.text = viewModel.weight
        configureColours(viewModel)
    }
    
    private func configureColours(_ viewModel: ExerciseCellViewModel) {
        switch viewModel.displayType {
        case .dark:
            repsImage.tintColor = UIColor.pisteRed
            weightImage.tintColor = UIColor.pisteRed
            repsLabel.textColor = UIColor.black
            weightLabel.textColor = UIColor.black
        case .light:
            repsImage.tintColor = UIColor.white
            weightImage.tintColor = UIColor.white
            repsLabel.textColor = UIColor.white
            weightLabel.textColor = UIColor.white
        }
    }

}
