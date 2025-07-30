//
//  PokemonCollectionCell.swift
//  pokemon-ios
//
//  Created by syndromme on 30/07/25.
//

import UIKit
import Kingfisher

class PokemonCollectionCell: UICollectionViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
    }
    
    func setPokemon(_ pokemon: Pokemon) {
        idLabel.text = pokemon.idFromURL
        nameLabel.text = pokemon.name.capitalized
        previewImage.kf.setImage(with: URL(string: String(format: artworkURL, pokemon.id ?? Int(pokemon.url?.split(separator: "/").last ?? "") ?? 0)))
    }
}
