//
//  ViewController.swift
//  PokemonDeck
//
//  Created by Chandan Sarkar on 17.06.17.
//  Copyright © 2017 Chandan. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var pokemonCollectionViewOutlet: UICollectionView!
    
    //Collection that will contain all the Pokemon objects
    var pokemonArray = [Pokemon]()
    
    //Creating the reference variable for the AudioPlayer
    var musicPlayer: AVAudioPlayer!
    
    //Creating the reference for the UISearchBar
    @IBOutlet weak var pokemonSearchBar: UISearchBar!
    
    //Creating smaller Pokemon array and searchMode to identify when we are typing
    var filteredPokemonArray = [Pokemon]()
    var searchMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonCollectionViewOutlet.delegate = self
        pokemonCollectionViewOutlet.dataSource = self
        pokemonSearchBar.delegate = self
        
        pokemonSearchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
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
            //Just declaring a Pokemon type variable which is yet to be initialised
            var pokemon: Pokemon!
            //If we are editing in the UISearchBar then the filtring will be done
            if searchMode {
                pokemon = filteredPokemonArray[indexPath.row]
                //Otherwise whole array will be considered
            }else{
                pokemon = pokemonArray[indexPath.row]
            }
            cell.configureCell(pokemon)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    //This is what happens when we tap on a cell. we will be performing Segue from it
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var pokemon: Pokemon!
        if searchMode{
            pokemon = filteredPokemonArray[indexPath.row]
        }else{
            pokemon = pokemonArray[indexPath.row]
        }
        performSegue(withIdentifier: "pokemonDetail", sender: pokemon)
    }
    
    //Preparing to perform Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetail" {
            if let destination = segue.destination as? DetailViewController{
                if let selectedPokemon = sender as? Pokemon{
                    destination.pokemon = selectedPokemon
                }
            }
        }
    }
    
    //No of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMode {
            return filteredPokemonArray.count
        }else{
            return pokemonArray.count
        }
    }
    
    //No of sections in CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Defines the size of the cells in UICollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    func initAudio(){
        let musicFilePath = Bundle.main.path(forResource: "music", ofType: "mp3")!
        let musicPathURL = URL(fileURLWithPath: musicFilePath)
        do{
            musicPlayer = try AVAudioPlayer(contentsOf: musicPathURL)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    
    
    @IBAction func controlMusic(_ sender: UIButton) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha = 0.2
        }else{
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    //This means whenever we make a keystroke in SearchBar, statements of this method will be called.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if pokemonSearchBar.text == nil || pokemonSearchBar.text == "" {
            searchMode = false
            //We ask the UICollectionView that something has changed in the datasource and data must be reloaded
            pokemonCollectionViewOutlet.reloadData()
            view.endEditing(true)
        }else{
            searchMode = true
            let lowercaseText = pokemonSearchBar.text!.lowercased()
            //We could have handled it in more longcut understandable way but we want to
            //learn the shortcut using a closure too.
            filteredPokemonArray = pokemonArray.filter({
                //$0 is a placeholder for each of the items in the original pokemon array
                //We are comparing each of the Pokemon object item in the array and checking if
                //what we have entered in the SearchBar is within the range of the pokemonName
                //We are including only those of the Pokemon whose pokemonName field comply with this
                //condition.
                //Much like the conventional if else condition check statement but a shortcut. We need to
                //learn this.
                $0.pokemonName.range(of: lowercaseText) != nil
            })
            //We ask the UICollectionView that something has changed in the datasource and data must be reloaded
            pokemonCollectionViewOutlet.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

