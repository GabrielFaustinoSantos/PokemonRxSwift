//
//  MoyaService.swift
//  TrainningRxSwiftComOsProsDaIteris
//
//  Created by Gabriel dos Santos Nascimento - GNS on 18/02/20.
//  Copyright © 2020 Gabriel dos Santos Nascimento - GNS. All rights reserved.
//

import Foundation
import Firebase
import RxCocoa
import RxSwift

protocol FirebaseContract{
    func sendData(name: String, pokemonType:String)
}


class FirebaseService{
    
    let db = Firestore.firestore()
    
    func sendData(name: String, pokemonType:String){
        
        var ref: DocumentReference? = nil
        ref = db.collection("trainers").addDocument(data: [
            "name": name,
            "pokemonType": pokemonType
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    func getDocument(collection:String) -> Observable<[[String:Any]]> {
        return Observable.create { (observer) -> Disposable in
            self.db.collection(collection).addSnapshotListener { (documentSnapShot, err) in
                guard let document = documentSnapShot else{
                    observer.onNext([])
                    return
                }
                observer.onNext(document.documents.map {$0.data()})
                
            }
            return Disposables.create()
        }
    }
    func getCollection(){
        db.collection("trainers").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.data())
                }
            }
        }
//    }
//    func deleteItems(){
//        db.collection("trainers").addSnapshotListener({ (documentSnapShot, <#Error?#>) in
//            <#code#>
//        }).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }
    }
}
