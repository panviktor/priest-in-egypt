//
//  LevelCell.swift
//  Priest in Egypt
//
//  Created by Viktor on 25.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class MyCell: UICollectionViewCell {
    weak var textLabel: UILabel!
    
    weak var imageLabel: UIImage!

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
        self.textLabel = textLabel
        self.contentView.backgroundColor = .lightGray
        self.textLabel.textAlignment = .center
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

        self.textLabel.text = nil
    }
    
    func openLevel(_ level: Bool) {
        level == true ? (textLabel.backgroundColor = .green) :  (textLabel.backgroundColor = .red)
    }
    
    func shrink(down: Bool) {
      UIView.animate(withDuration: 0.6) {
        if down {
          self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }  else {
          self.transform = .identity
        }
      }
    }
    
    
    override var isHighlighted: Bool {
      didSet {
        shrink(down: isHighlighted)
      }
    }
}
