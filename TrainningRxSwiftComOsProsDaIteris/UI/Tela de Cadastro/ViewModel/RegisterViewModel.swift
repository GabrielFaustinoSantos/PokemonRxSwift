//
//  RegisterViewModel.swift
//  TrainningRxSwiftComOsProsDaIteris
//
//  Created by Gabriel dos Santos Nascimento - GNS on 18/02/20.
//  Copyright © 2020 Gabriel dos Santos Nascimento - GNS. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa
import RxSwift

protocol RegisterViewModelContract{
    func createDocument(name:String, pokemonType:String)
    var pokemonDrive:Driver<[PokemonTrainers]> {get}
    var pokeFavoriteDrive:Driver<[PokemonTypes]> {get}
}


class RegisterViewModel{
    
    let db = Firestore.firestore()
    let service = FirebaseService()
    let pokemonRelay:BehaviorRelay<[PokemonTrainers]> = BehaviorRelay(value: [])
    var pokemonDrive:Driver<[PokemonTrainers]> {return pokemonRelay.asDriver()}
    
    let pokeFavoriteRelay:BehaviorRelay<[String]> = BehaviorRelay(value: [])
    var pokeFavoriteDrive:Driver<[String]> {return pokeFavoriteRelay.asDriver()}
    
    let disposeBag = DisposeBag()
    
    public func getTrainers(){
        
        service.getDocument(collection: "trainers").subscribe(onNext: { (trainers) in
            
            var listTrainer:[PokemonTrainers] = []
            
            trainers.forEach { (dict) in
                
                listTrainer.append(PokemonTrainers(name: dict["name"] as? String ?? "",
                                                   pokemonType: dict["pokemonType"] as? String ?? ""))
            }
            self.pokemonRelay.accept(listTrainer)
        }).disposed(by: disposeBag)
    }
    
    public func getFavoritePokemons(){
        
        service.getDocument(collection: "pokemonTypes").subscribe(onNext: { (types) in
            
            var pokeTypes = types[0]["types"] as? [String]
            
            self.pokeFavoriteRelay.accept(pokeTypes ?? [])
        }).disposed(by: disposeBag)
    }
    
    
    func createDocument(name:String, pokemonType:String){
        service.sendData(name: name, pokemonType: pokemonType)
    }
    
    func didResqueteFavoritePokemon(index:Int) -> String{
        return pokeFavoriteRelay.value[index]
    }
    
    
}
