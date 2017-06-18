//
//  DetailViewController.swift
//  PokemonDeck
//
//  Created by Chandan Sarkar on 18.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mainImageOutlet: UIImageView!
    @IBOutlet weak var bioLabelOutlet: UILabel!
    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var typeLabelOutlet: UILabel!
    @IBOutlet weak var heightLabelOutlet: UILabel!
    @IBOutlet weak var weightLabelOutlet: UILabel!
    @IBOutlet weak var defenseLabelOutlet: UILabel!
    @IBOutlet weak var pokedexIdLabelOutlet: UILabel!
    @IBOutlet weak var baseAttackLabelOutlet: UILabel!
    @IBOutlet weak var currentEvoImageOutlet: UIImageView!
    @IBOutlet weak var nextEvoImageOitlet: UIImageView!
    @IBOutlet weak var evoheadingLabelOutlet: UILabel!
    
    
    private var _pokemon: Pokemon!
    
    var pokemon: Pokemon{
        get{
            return _pokemon
        }
        set{
            _pokemon = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabelOutlet.text = pokemon.pokemonName
        pokemon.downLoadPokemonInformation {
            //Whatever we call inside this closure will execute when the download is complete.
            self.updateUI()
        }
    }
    
    func updateUI(){
        nameLabelOutlet.text = pokemon.pokemonName.capitalized
        typeLabelOutlet.text = pokemon.pokemonType
        heightLabelOutlet.text = pokemon.pokemonHeight
        weightLabelOutlet.text = pokemon.pokemonWeight
        defenseLabelOutlet.text = pokemon.pokemonDefense
        pokedexIdLabelOutlet.text = String(pokemon.pokedexId)
        baseAttackLabelOutlet.text = pokemon.pokemonBaseAttack
        mainImageOutlet.image = UIImage(named: String(pokemon.pokedexId))
        currentEvoImageOutlet.image = UIImage(named: String(pokemon.pokedexId))
        
        if pokemon.pokemonNextEvoId == "" {
            evoheadingLabelOutlet.text = "No Evolution"
            nextEvoImageOitlet.isHidden = true
        }else{
            let evoLabel = "Next Evolution \(pokemon.pokemonNextEvoName) \(pokemon.pokemonNextEvolutionLevel)"
            evoheadingLabelOutlet.text = evoLabel
            nextEvoImageOitlet.isHidden = false
            nextEvoImageOitlet.image = UIImage(named: pokemon.pokemonNextEvoId)
        }
        bioLabelOutlet.text = pokemon.pokemonBio
    }
    
    //Provides Implementation of the Backbutton pressed
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
