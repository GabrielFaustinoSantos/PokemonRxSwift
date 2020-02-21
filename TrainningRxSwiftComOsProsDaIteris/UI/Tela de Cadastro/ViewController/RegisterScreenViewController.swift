//
//  ViewController.swift
//  TrainningRxSwiftComOsProsDaIteris
//
//  Created by Gabriel dos Santos Nascimento - GNS on 18/02/20.
//  Copyright © 2020 Gabriel dos Santos Nascimento - GNS. All rights reserved.
//

import UIKit
import Firebase
import RxCocoa
import RxSwift

class RegisterScreenViewController: UIViewController{
    
    
    
    @IBOutlet weak var coachName: UITextField!
    @IBOutlet weak var favoritePokemon: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var buttonBorder: UIButton!
    let teste = RegisterViewModel()
    let firebaseStore = FirebaseService()
    let disposeBag = DisposeBag()
    
    let trainerArray = [
        PokemonTrainers(name: "Teste", pokemonType: "Teste"),
        PokemonTrainers(name: "Teste", pokemonType: "Teste"),
        PokemonTrainers(name: "Teste", pokemonType: "Teste"),
        PokemonTrainers(name: "Teste", pokemonType: "Teste"),
        PokemonTrainers(name: "Teste", pokemonType: "Teste")
    ]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        servicesFirebase()
        buttonBorder.layer.cornerRadius = 15
        coachName.layer.cornerRadius = 15
        favoritePokemon.layer.cornerRadius = 15
        
        coachName.layer.masksToBounds = true
        favoritePokemon.layer.masksToBounds = true
        tableview.keyboardDismissMode = .onDrag
        
    }
    
    func servicesFirebase(){
        firebaseStore.getCollection()
    }
    
    let pickerView:UIPickerView = UIPickerView()
    
    @IBAction func registerPokeInfo(_ sender: Any) {
        teste.createDocument(name: coachName.text!, pokemonType: favoritePokemon.text!)
        
        guard let name = coachName.text, !name.isEmpty, let pokeType = favoritePokemon.text, !pokeType.isEmpty else{
             let alert = UIAlertController(title: "Opa Amigao, tem alguma coisa errada", message: "Verifica ai pai", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dennovo", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return}
        
        let alert = UIAlertController(title: "Cadastro Realizado com NinaSsso", message: "Parabens", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OKAy PESSOAL", style: .default, handler: { _ in
            self.coachName.text = ""
            self.favoritePokemon.text = ""
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    private func bind() {
        teste.getTrainers()
        teste.pokemonDrive.drive(tableview.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)){items, model, cell in
            cell.title.text = model.name
            cell.outraLabel.text = model.pokemonType
        }.disposed(by: disposeBag)
        teste.getFavoritePokemons()
        teste.pokeFavoriteDrive.drive(pickerView.rx.itemTitles) { row, model in return model
            self.pickerView
            
        }.disposed(by: disposeBag)
        pickerView.rx.itemSelected
            .subscribe(onNext: { (row, value) in
                self.favoritePokemon.text = self.teste.didResqueteFavoritePokemon(index: row)
            }).disposed(by: disposeBag)
        favoritePokemon.inputView = pickerView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    
    
}
