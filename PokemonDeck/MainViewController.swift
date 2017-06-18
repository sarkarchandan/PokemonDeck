//
//  ViewController.swift
//  PokemonDeck
//
//  Created by Chandan Sarkar on 17.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var pokemonCollectionViewOutlet: UICollectionView!
    
    //Collection that will contain all the Pokemon objects
    var pokemonArray = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonCollectionViewOutlet.delegate = self
        pokemonCollectionViewOutlet.dataSource = self
        
        parsePokemonCSV()
    }
    
    //We want to parse the pokemon.csv file and populate the array of Pokemon type
    func parsePokemonCSV(){
        let csvPath = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        //Our CSV parsing could also through an error so we will handle it inside do catch block
        do{
            let csv = try CSV(contentsOfURL: csvPath)
            let rows = csv.rows
            
            for pokeInformation in rows{
                let pokemonName = pokeInformation["identifier"]!
                let pokemonId = Int(pokeInformation["id"]!)!
                let pokemon = Pokemon(pokemonName: pokemonName, pokedexId: pokemonId)
                pokemonArray.append(pokemon)
            }
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }

    //As always this is where we are going to create our cell and support the scroll behaviour
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as? PokemonCollectionViewCell{
            let pokemon = pokemonArray[indexPath.row]
            cell.configureCell(pokemon)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    //This is what happens when we tap on a cell. we will be performing Segue from it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //TODO
    }
    
    //No of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonArray.count
    }
    
    //No of sections in CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Defines the size of the cells in UICollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
}

