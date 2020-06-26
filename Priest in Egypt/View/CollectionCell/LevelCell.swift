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
    let imageLevel: UIImage?
    let textLevel: String
}

class MyCell: UICollectionViewCell {
    weak var textLevelLabel: UILabel!
    weak var imageLevelView: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            shrink(down: isHighlighted)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let textLabel = UILabel(frame: .zero)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.textLevelLabel = textLabel
        
        let imageView =  UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            textLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
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
        self.textLevelLabel.text = nil
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
        self.contentView.backgroundColor = .clear
        self.textLevelLabel.textAlignment = .center
        
        self.imageLevelView.contentMode = UIView.ContentMode.scaleAspectFit
        self.imageLevelView.layer.cornerRadius = 15
        self.imageLevelView.clipsToBounds =  true
        self.imageLevelView.layer.borderWidth = 1.5
        self.imageLevelView.layer.borderColor = #colorLiteral(red: 0.84406358, green: 0.3853197992, blue: 0.2750463486, alpha: 1)
    }
    
    //FIXME: - add cache
    private func grayscaleConverter(_ image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        guard let ciImage = CIImage(image: image) else { return nil }
        let blackAndWhiteCIImage = ciImage.applyingFilter("CIColorControls", parameters: ["inputSaturation": 0, "inputContrast": 1])
        let blackAndWhiteImage = UIImage(ciImage: blackAndWhiteCIImage)
        return blackAndWhiteImage
    }
    
    func configure(_ data: CellLevelData) {
        textLevelLabel.text = data.textLevel 
        data.openLevel == true ? (imageLevelView.image = data.imageLevel) : (imageLevelView.image = grayscaleConverter(data.imageLevel))
    }
}
