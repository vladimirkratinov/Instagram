//
//  SignInHeaderView.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-23.
//

import UIKit

class SignInHeaderView: UIView {
    
    private var gradientLayer: CALayer?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "racoon_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        createGradient()
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemYellow.cgColor, UIColor.systemGreen.cgColor]
        gradientLayer.frame = layer.bounds
        layer.addSublayer(gradientLayer)
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = layer.bounds
        gradientLayer?.cornerRadius = 10
        gradientLayer?.borderWidth = 6
        gradientLayer?.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.frame = CGRect(x: width/4, y: 20, width: width/2, height: height-40)
    }
}
