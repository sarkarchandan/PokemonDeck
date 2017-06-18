//
//  Pokemon.swift
//  PokemonDeck
//
//  Created by Chandan Sarkar on 17.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import Foundation

//Defining Pokemon as a custom datatype
class Pokemon{
    
    //Pokemon class member variables
    fileprivate var _pokemonName: String!
    fileprivate var _pokedexId: Int!
    
    //Getter and Setter
    var pokemonName: String{
        get{
            return _pokemonName
        }
        set{
            _pokemonName = newValue
        }
    }
    
    var pokedexId: Int{
        get{
            return _pokedexId
        }
        set{
            _pokedexId = newValue
        }
    }
    
    //Initialiser for the Pokemon class
    init(pokemonName: String,pokedexId: Int) {
        self._pokemonName = pokemonName
        self._pokedexId = pokedexId
    }
}
