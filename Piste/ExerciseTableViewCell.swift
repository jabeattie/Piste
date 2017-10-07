//
//  ExerciseViewCellTableViewCell.swift
//  Piste
//
//  Created by James Beattie on 02/07/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
