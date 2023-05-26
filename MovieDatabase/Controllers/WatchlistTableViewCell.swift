//
//  WatchlistTableViewCell.swift
//  MovieDatabase
//
//  Created by jazeps.ivulis on 24/05/2023.
//

import UIKit

class WatchlistTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { finished in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                }
            })
        }
    }
}
