//
//  MenuGameController.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

protocol MenuViewControllerDelegate: class {
    func update(maxLevel: Int)
}


class MenuViewController: UIViewController, BlurViewDelegate, MenuViewControllerDelegate {
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var musicButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var topScoreButton: UIButton!
    weak var collectionView: UICollectionView!
    
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "Mining by Moonlight", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }()
    
    private var musicStatus = true
    private var currentUnlockedLevel = 1
    private var selectedLevel: Int!
    private var levelTapped = false
    
    private let scoreManager = ScoreManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic()
        setupButtons()
        currentUnlockedLevel = scoreManager.currentLevel
        levelLabel.text = "You unlocked a level \(scoreManager.currentLevel)"
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
    }
    
    
    override func loadView() {
        super.loadView()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delaysContentTouches = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.levelLabel.bottomAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: self.playButton.topAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
        ])
        self.collectionView = collectionView
    }
    
    private func playMusic() {
        DispatchQueue.main.async {
            self.backgroundMusic?.play()
        }
    }
    
    @IBAction func musicToggle(_ sender: UIButton) {
        sender.pulsate(_repeatCount: 3)
        musicStatus.toggle()
        musicStatus == true ? playMusic() : backgroundMusic?.stop()
    }
    
    @IBAction func topScore() {
        let blurVC = ScoreViewController()
        blurVC.modalPresentationStyle = .custom
        present(blurVC, animated: true, completion: nil)
        setBlurView()
        blurVC.delegate = self
    }
    
    func setBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .extraLight)
        view.addSubview(blurView)
    }
    
    func removeBlurView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    func update(maxLevel: Int) {
        if maxLevel >= scoreManager.currentLevel {
            currentUnlockedLevel = maxLevel
            self.levelLabel.text = "You unlocked a level \(maxLevel) out of 10"
        }
        collectionView.reloadData()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? GameViewController else { return }
        if levelTapped {
            destination.currentLevelNum = selectedLevel
        } else {
            destination.currentLevelNum = currentUnlockedLevel
        }
        destination.delegate = self
    }
    
    @IBAction func unwind( _ segue: UIStoryboardSegue) {}
    
    func setupButtons() {
        musicButton.layer.cornerRadius = 15
        playButton.layer.cornerRadius = 15
        topScoreButton.layer.cornerRadius = 15
    }
}

//MARK: - UICollectionViewDataSource
extension MenuViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.textLabel.text = String(indexPath.row + 1)
        cell.openLevel(indexPath.row + 1 <= currentUnlockedLevel)
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row + 1)
        if (indexPath.row + 1) <= currentUnlockedLevel {
            selectedLevel = indexPath.row + 1
            levelTapped = true
        }
    }
}

//MARK: - UICollectiUICollectionViewDelegateFlowLayoutonViewDelegate
extension MenuViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.size.width / 1.5) , height: collectionView.bounds.size.height - 50)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
}
