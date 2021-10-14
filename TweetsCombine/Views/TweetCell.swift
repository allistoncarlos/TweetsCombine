//
//  TweetCell.swift
//  TweetsCombine
//
//  Created by Alliston Aleixo on 14/10/21.
//

import UIKit

class TweetCell: UITableViewCell {
    let nameLabel = UILabel(text: "Username",
                            font: .boldSystemFont(ofSize: 16),
                            textColor: .systemGray)
    
    let tweetTextLabel = UILabel(text: "Tweet Text MultiLines",
                                 font: .systemFont(ofSize: 16),
                                 textColor: .darkGray,
                                 numberOfLines: 0)
        
    let profileImageView = UIImageView(image: nil,
                                       contentMode: .scaleAspectFill)
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        profileImageView.layer.cornerRadius = 8
        profileImageView.layer.borderWidth = 0.5
        
        hstack(
            profileImageView.withSize(.init(width: 50, height: 50)),
               stack(nameLabel, tweetTextLabel, spacing: 8),
               spacing: 20,
               alignment: .top)
            .withMargins(.allSides(24))
    }
        
    required init?(coder: NSCoder) {
        fatalError()
    }
}
