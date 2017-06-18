//
//  PokemonCollectionViewCell.swift
//  PokemonDeck
//
//  Created by Chandan Sarkar on 18.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageViewOutlet: UIImageView!
    @IBOutlet weak var pokemonNameLabelOutlet: UILabel!
    
    var pokemon: Pokemon!
    
    //This is where we could implement the rounded corner
    //Each View has a layer level cell where we can customize how the View should look at runtime
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        pokemonNameLabelOutlet.text = self.pokemon.pokemonName.capitalized
        pokemonImageViewOutlet.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
