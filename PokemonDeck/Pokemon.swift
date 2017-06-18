//
//  Pokemon.swift
//  PokemonDeck
//
//  Created by Chandan Sarkar on 17.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import Foundation
import Alamofire

//Defining Pokemon as a custom datatype
class Pokemon{
    
    //Pokemon class member variables
    private var _pokemonName: String!
    private var _pokedexId: Int!
    private var _pokemonBio: String!
    private var _pokemonType: String! //D
    private var _pokemonHeight: String! //D
    private var _pokemonWeight: String! //D
    private var _pokemonDefense: String! //D
    private var _pokemonBaseAttack: String! //D
    private var _pokemonNextEvo: String!
    private var _pokemonNextEvoName: String!
    private var _pokemonNextEvoId: String!
    private var _pokemonNextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    
    //Getter and Setter
    var pokemonName: String{
        get{
            if _pokemonName == nil{
                return ""
            }else{
                return _pokemonName
            }
        }
        set{
            _pokemonName = newValue
        }
    }
    
    var pokedexId: Int{
        get{
            if _pokedexId == nil{
                return -1
            }else{
                return _pokedexId
            }
        }
        set{
            _pokedexId = newValue
        }
    }
    
    var pokemonBio: String{
        get{
            if _pokemonBio == nil{
                return ""
            }else{
                return _pokemonBio
            }
        }
        set{
            _pokemonBio = newValue
        }
    }
    
    var pokemonType: String{
        get{
            if _pokemonType == nil{
                return ""
            }else{
                return _pokemonType
            }
        }
        set{
            _pokemonType = newValue
        }
    }
    
    var pokemonHeight: String{
        get{
            if _pokemonHeight == nil{
                return ""
            }else{
                return _pokemonHeight
            }
        }
        set{
            _pokemonHeight = newValue
        }
    }
    
    var pokemonWeight: String{
        get{
            if _pokemonWeight == nil{
                return ""
            }else{
                return _pokemonWeight
            }
        }
        set{
            _pokemonWeight = newValue
        }
    }
    
    var pokemonDefense: String{
        get{
            if _pokemonDefense == nil{
                return ""
            }else{
                return _pokemonDefense
            }
        }
        set{
            _pokemonDefense = newValue
        }
    }
    
    var pokemonBaseAttack: String{
        get{
            if _pokemonBaseAttack == nil{
                return ""
            }else{
                return _pokemonBaseAttack
            }
        }
        set{
            _pokemonBaseAttack = newValue
        }
    }
    
    var pokemonNextEvo: String{
        get{
            if _pokemonNextEvo == nil{
                return ""
            }else{
                return _pokemonNextEvo
            }
        }
        set{
            _pokemonNextEvo = newValue
        }
    }
    
    var pokemonURL: String{
        get{
            if _pokemonURL == nil{
                return ""
            }else{
                return _pokemonURL
            }
        }
        set{
            _pokemonURL = newValue
        }
    }
    
    var pokemonNextEvoName: String{
        get{
            if _pokemonNextEvoName == nil{
                return ""
            }else{
                return _pokemonNextEvoName
            }
        }
        set{
            _pokemonNextEvoName = newValue
        }
    }
    
    var pokemonNextEvoId: String{
        get{
            if _pokemonNextEvoId == nil{
                return ""
            }else{
                return _pokemonNextEvoId
            }
        }
        set{
            _pokemonNextEvoId = newValue
        }
    }
    
    var pokemonNextEvolutionLevel: String{
        get{
            if _pokemonNextEvolutionLevel == nil{
                return ""
            }else{
                return _pokemonNextEvolutionLevel
            }
        }
        set{
            _pokemonNextEvolutionLevel = newValue
        }
    }
    
    
    //Initialiser for the Pokemon class
    init(pokemonName: String,pokedexId: Int) {
        self._pokemonName = pokemonName
        self._pokedexId = pokedexId
        self._pokemonURL = "\(BASE_URL)\(POKEMON_URL)\(pokedexId)/"
    }
    
    func downLoadPokemonInformation(downloadComplete: @escaping DownloadComplete){
        Alamofire.request(pokemonURL).responseJSON { response in
            
            if let pokemonDictionary = response.result.value as? Dictionary<String,Any> {
                //Weight
                if let weight = pokemonDictionary["weight"] as? String{
                    self.pokemonWeight = weight
                    print(self.pokemonWeight)
                }
                //Height
                if let height = pokemonDictionary["height"] as? String{
                    self.pokemonHeight = height
                    print(self.pokemonHeight)
                }
                //Base Attack
                if let attack = pokemonDictionary["attack"] as? Int{
                    self.pokemonBaseAttack = "\(attack)"
                    print(self.pokemonBaseAttack)
                }
                //Defense
                if let defense = pokemonDictionary["defense"] as? Int{
                    self.pokemonDefense = "\(defense)"
                    print(self.pokemonDefense)
                }
                //Types
                var separatedType = ""
                if let types = pokemonDictionary["types"] as? [Dictionary<String,Any>], types.count > 0{
                    for eachTypeDict in types{
                        if let eachType = eachTypeDict["name"] as? String{
                            separatedType += eachType.capitalized + " /"
                        }
                    }
                    let refinedType = String(separatedType.characters.dropLast())
                    self.pokemonType = refinedType
                    print(refinedType)
                }else{
                    self.pokemonType = ""
                }
                //Bio/Descriptions
                if let descriptionArray = pokemonDictionary["descriptions"] as? [Dictionary<String,String>] , descriptionArray.count > 0 {
                    if let partialDescriptionUri = descriptionArray[0]["resource_uri"]{
                        let descriptionUri = "\(BASE_URL)\(partialDescriptionUri)"
                        
                        Alamofire.request(descriptionUri).responseJSON(completionHandler: { descriptionResponse in
                            
                            if let descriptionDictionary = descriptionResponse.result.value as? Dictionary<String,Any>{
                                if let desc = descriptionDictionary["description"] as? String{
                                    let refinedDescription = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self.pokemonBio = refinedDescription
                                    print(self.pokemonBio)
                                }
                            }
                            downloadComplete()
                        })
                    }
                }else {
                    self.pokemonBio = ""
                }
                
                //Evolutions
                if let evolutions = pokemonDictionary["evolutions"] as? [Dictionary<String,Any>] , evolutions.count > 0{
                    if let evolutionName = evolutions[0]["to"] as? String{
                        if evolutionName.range(of: "mega") == nil{ //We want to discard mega Pokemons
                            //Getting name
                            self.pokemonNextEvoName = evolutionName
                            
                            //Extracting the EvoId from the uri that is provided
                            if let evolutionResourceUri = evolutions[0]["resource_uri"] as? String{
                                let replacedFirstPart = evolutionResourceUri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let evoultionId = replacedFirstPart.replacingOccurrences(of: "/", with: "")
                                
                                //Getting Id
                                self.pokemonNextEvoId = evoultionId
                            }
                            //Extracting Evolution Level
                            if let nextEvolutionLevelExist = evolutions[0]["level"]{
                                
                                if let evolutionLevel = nextEvolutionLevelExist as? Int{
                                    
                                    //Getting Level
                                    self.pokemonNextEvolutionLevel = "\(evolutionLevel)"
                                }
                            }else{
                                self.pokemonNextEvolutionLevel = ""
                            }
                            print(self.pokemonNextEvolutionLevel)
                            print(self.pokemonNextEvoId)
                            print(self.pokemonNextEvoName)
                        }
                    }
                    
                }
                downloadComplete()
            }
        }
    }
    
    
}
