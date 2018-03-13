import UIKit

//This class will make the button round.
class circleButton: UIButton {
    //Make this variable tweakable in the storyboard view.
    @IBInspectable var cornerRadius: CGFloat = 30.0 {
        didSet {
            setupView()
        }
    }
    
    //Circlify the square button.
    func setupView() {
        layer.cornerRadius = cornerRadius
    }
}
