//
//  PostDateTimeCollectionViewCell.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-24.
//

import UIKit

final class PostDateTimeCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostDateTimeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: PostDateTimeCollectionViewCellViewModel) {
        
    }
}
