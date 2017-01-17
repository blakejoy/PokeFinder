//
//  PokeCellCollectionViewCell.swift
//  PokeFinder
//
//  Created by Blake Joynes on 1/15/17.
//  Copyright © 2017 BJ. All rights reserved.
//

import UIKit

class PokeCellCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var thumbImage: UIImageView!

  @IBOutlet weak var pokemonNameLbl: UILabel!
  var pokemon: Pokemon!
  
  func configureCell(_ pokemon : Pokemon){
    self.pokemon = pokemon
    
    pokemonNameLbl.text = self.pokemon.pokemonName
    thumbImage.image = UIImage(named: "\(self.pokemon.pokemonNumber)")
  }
  
  
  
  
}
