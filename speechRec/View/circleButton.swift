import UIKit

class circleButton: UIButton
{
    @IBInspectable var cornerRadius: CGFloat = 30.0
    {
        didSet
        {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder()
    {
        setupView()
    }
    
    func setupView()
    {
        layer.cornerRadius = cornerRadius
    }
}
