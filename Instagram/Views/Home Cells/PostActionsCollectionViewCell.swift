//
//  PostActionsCollectionViewCell.swift
//  Instagram
//
//  Created by Vladimir Kratinov on 2023-02-24.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate: AnyObject {
    func postActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool)
    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell)
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell)
}

final class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostActionsCollectionViewCell"
    
    weak var delegate: PostActionsCollectionViewCellDelegate?
    
    private var isLiked = false
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        // Actions:
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapLike() {
        if self.isLiked {
            let image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        }
        else {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
        
        delegate?.postActionsCollectionViewCellDidTapLike(self, isLiked: !isLiked)
        
        self.isLiked = !isLiked
    }
    
    @objc func didTapComment() {
        delegate?.postActionsCollectionViewCellDidTapComment(self)
    }
    
    @objc func didTapShare() {
        delegate?.postActionsCollectionViewCellDidTapShare(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.height/1.5
        likeButton.frame = CGRect(x: 10, y: (contentView.height-size)/2, width: size, height: size-3)
        commentButton.frame = CGRect(x: likeButton.right+12, y: (contentView.height-size)/2, width: size, height: size-3)
        shareButton.frame = CGRect(x: commentButton.right+12, y: (contentView.height-size)/2, width: size, height: size-3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: PostActionsCollectionViewCellViewModel) {
        isLiked = viewModel.isLiked
        if viewModel.isLiked {
            let image = UIImage(systemName: "heart.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
    }
}
