//
//  PostLikesCollectionViewCell.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-24.
//

import UIKit

final class PostLikesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostLikesCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Helvetica", size: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 12, y: 0, width: contentView.width-12, height: (contentView.height)/3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: PostLikesCollectionViewCellViewModel) {
        let users = viewModel.likers
        label.text = "\(users.count) Likes"
    }
}
