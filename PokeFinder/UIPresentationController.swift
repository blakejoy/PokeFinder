//
//  UIPresentationController.swift
//  PokeFinder
//
//  Created by Blake Joynes on 1/15/17.
//  Copyright © 2017 BJ. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class UIPresentationController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate,CLLocationManagerDelegate{

  @IBOutlet var collection: UICollectionView!

  @IBOutlet weak var searchBar: UISearchBar!

  var geoFire: GeoFire!
  var geoFireRef: FIRDatabaseReference!


  var inSearchMode = false
  var pokemon = [Pokemon]()
  var filteredPokemon = [Pokemon]()
  var mapView: MKMapView!
 
  
override func viewDidLoad() {
  super.viewDidLoad()
  collection.dataSource = self
  collection.delegate = self
  searchBar.delegate = self
  
  geoFireRef = FIRDatabase.database().reference()
  geoFire = GeoFire(firebaseRef: geoFireRef)
  searchBar.returnKeyType = UIReturnKeyType.done
  
  loadPokemonList()
}

  
  func createSighting(forLocation location: CLLocation,withPokemon pokeNumber: Int){
    geoFire.setLocation(location, forKey: "\(pokeNumber)")
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if inSearchMode{
    return filteredPokemon.count
    }else{
      return pokemon.count
    }
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "Poke Cell Collection View Cell", for: indexPath) as? PokeCellCollectionViewCell{
      
      let poke: Pokemon!
      
      if inSearchMode{
        poke = filteredPokemon[indexPath.row]
        cell.configureCell(poke)
        
      }else{
        poke = pokemon[indexPath.row]
        cell.configureCell(poke)
      }
      
      
      return cell
    }else{
      return UICollectionViewCell()
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let loc = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    
    var poke:Pokemon!

  
    if inSearchMode{
      poke = filteredPokemon[indexPath.row]
    }else{
      poke  = pokemon[indexPath.row]
    }
    
    showSightingOnMap(location: loc)
    
    createSighting(forLocation: loc, withPokemon: poke.pokemonNumber)
    
    self.dismiss(animated: true, completion: {})

  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    view.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text == nil || searchBar.text == ""{
    inSearchMode = false
      collection.reloadData()
      view.endEditing(true)
    }else{
      inSearchMode = true
      let lower = searchBar.text!
      filteredPokemon = pokemon.filter({$0.pokemonName.range(of: lower) != nil})
      collection.reloadData()
    }
  }
  
  
  func showSightingOnMap(location: CLLocation){
    let circleQuery = geoFire!.query(at: location, withRadius: 2.5)
    
    _ = circleQuery?.observe(GFEventType.keyEntered, with: {(key,location) in
      
      if let key = key, let location = location {
        let anno = PokeAnnotation(coordinate: location.coordinate, pokemonNumber: Int(key)!)
        self.mapView.addAnnotation(anno)
      }
      
    })
  }
  
  
  func loadPokemonList(){
    for i in 1..<152 {
    let poke = Pokemon(number: i )
    pokemon.append(poke)
    
    }
  }
  
  


}
