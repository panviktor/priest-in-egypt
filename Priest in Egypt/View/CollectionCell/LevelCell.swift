//
//  LevelCell.swift
//  Priest in Egypt
//
//  Created by Viktor on 25.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

struct CellLevelData {
    let openLevel: Bool
    let imageLevel: String
    let textLevel: String
}

class MyCell: UICollectionViewCell {
    weak var imageLevelView: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            shrink(down: isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView =  UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.imageLevelView = imageView
        configureGUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("Interface Builder is not supported!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        fatalError("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageLevelView.image = nil
    }
    
    private func shrink(down: Bool) {
        UIView.animate(withDuration: 0.6) {
            if down {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }  else {
                self.transform = .identity
            }
        }
    }
    
    private func configureGUI() {
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.contentView.layer.cornerRadius = 15
        self.imageLevelView.contentMode = UIView.ContentMode.scaleAspectFit
        self.imageLevelView.layer.cornerRadius = 15
        self.imageLevelView.clipsToBounds =  true
        self.imageLevelView.layer.borderWidth = 1.5
        self.imageLevelView.layer.borderColor = #colorLiteral(red: 0.8459544182, green: 0.5704818368, blue: 0.2523650527, alpha: 1)
    }
    
    func configure(_ data: CellLevelData) {
       data.openLevel == true ? (imageLevelView.image = UIImage(named: data.imageLevel)) : (imageLevelView.image = UIImage(named: "\(data.imageLevel)BW"))
    }
}
