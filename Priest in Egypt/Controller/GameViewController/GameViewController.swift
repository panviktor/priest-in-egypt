import SpriteKit
import UIKit
import AVFoundation

class GameViewController: UIViewController {
    // MARK: Properties
    // The scene draws the tiles and cookie sprites, and handles swipes.
    var scene: GameScene!
    var level: Level!
    var movesLeft = 0
    var score = 0
    var totalScore = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    var currentLevelNum: Int!
    let scoreManager = ScoreManager()
    
    weak var delegate: MenuViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet var gameOverPanel: UIImageView!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var movesLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var shuffleButton: UIButton!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var scoreStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonUI()
        setupLevel(number: currentLevelNum)
    }
    
    fileprivate func setupButtonUI() {
        shuffleButton.setImage(UIImage(named: "Shuffle"), for: .normal)
        shuffleButton.setImage(UIImage(named: "ShufflePress"), for: .highlighted)
        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        exitButton.setImage(UIImage(named: "ExitPress"), for: .highlighted)
    }

   fileprivate func sizeDetector(_ currentLevel: Int) -> (CGFloat, CGFloat) {
        let w: CGFloat = UIScreen.main.bounds.width
        let h: CGFloat = UIScreen.main.bounds.height
        var tileWidth: CGFloat
        var tileHeight: CGFloat
        tileWidth = (w / (CGFloat(level.numColumns)) * 0.98)
        tileHeight =  (h / (CGFloat(level.numRows)) * 0.60)
        return (tileWidth, tileHeight)
    }
    
    func setupLevel(number levelNumber: Int) {
         level = Level(filename: "Level_\(levelNumber)")
        
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        var tileWidth: CGFloat
        var tileHeight: CGFloat
        
        (tileWidth, tileHeight) = sizeDetector(currentLevelNum)
        
        scene = GameScene(size: skView.bounds.size, tileWidth: tileWidth, tileHeight: tileHeight)
        scene.scaleMode = .aspectFill
        
        // Setup the level.
        scene.level = level
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        gameOverPanel.isHidden = true
        shuffleButton.isHidden = true
        // Present the scene.
        skView.presentScene(scene)
        
        // Start the game.
        beginGame()
    }
    
    // MARK: IBActions
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        shuffle()
        sender.rotate()
        decrementMoves()
    }
    
    // MARK: View Controller Functions
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()
        level.resetComboMultiplier()
        scene.animateBeginGame {
            self.shuffleButton.isHidden = false
        }
        shuffle()
    }
    
    func shuffle() {
        scene.removeAllCookieSprites()
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    func handleSwipe(_ swap: Swap) {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animate(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        
        scene.animateMatchedCookies(for: chains) {
            for chain in chains {
                self.score += chain.score
            }
            
            self.updateLabels()
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(in: columns) {
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(in: columns) {
                    self.handleMatches()
                }
            }
        }
    }
    
    func beginNextTurn() {
        level.detectPossibleSwaps()
        view.isUserInteractionEnabled = true
        decrementMoves()
    }
    
    func updateLabels() {
        exitButton.isHidden = false
        //        scoreStack.isHidden = false
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
    }
    
    @IBAction func exitPressed(_ sender: UIButton) {
        delegate?.update(maxLevel: currentLevelNum)
    }
    
    func decrementMoves() {
        movesLeft -= 1
        updateLabels()
        if score >= level.targetScore {
            totalScore += score
            exitButton.isHidden = true
            gameOverPanel.image = UIImage(named: "LevelComplete")
            
            //MARK: - Current Level Num
            if currentLevelNum < 11 {
                currentLevelNum += 1
                delegate?.update(maxLevel: currentLevelNum)
                self.scoreManager.addNewUnlockedLevel(currentLevelNum)
            } else {
                print("WINNNNNNNNNNNNNN")
                currentLevelNum = 1
                presentWinController()
            }
            showGameOver()
        } else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }
    
    func showGameOver() {
        scoreManager.appendNewScore(totalScore)
        
        totalScore = 0
        gameOverPanel.isHidden = false
        scene.isUserInteractionEnabled = false
        shuffleButton.isHidden = true
        
        scene.animateGameOver {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    @objc func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        gameOverPanel.isHidden = true
        scene.isUserInteractionEnabled = true
        setupLevel(number: currentLevelNum)
    }
    
}

//MARK: - WinViewController Present
extension GameViewController: BlurViewDelegate {
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
    
    func presentWinController() {
        let winVC = WinViewController()
        winVC.modalPresentationStyle = .custom
        present(winVC, animated: true, completion: nil)
        setBlurView()
        winVC.delegate = self
    }
}
