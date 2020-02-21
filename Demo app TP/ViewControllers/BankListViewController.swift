//
//  BankListViewController.swift
//  Demo app TP
//
//  Created by Jonathan Pabel Saldivar Mendoza on 20/02/20.
//  Copyright © 2020 Jonathan Pabel Saldivar Mendoza. All rights reserved.
//

import UIKit
import CoreData

class BankListViewController: UIViewController {

    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let urlSession = URLSession(configuration: .default)
    var dataSource:[BankModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(isLocalData: false)
        fetchBankList()
        
    }
    
    func fetchBankList() {
        fetchLocalBankList { (banks, error) in
            if let error = error {
                print(error)
                self.showAlert()
            } else {
                if !banks.isEmpty {
                    self.dataSource = banks
                    self.updateView()
                } else {
                    self.fetchBankListService { (banks, error) in
                        if let error = error {
                            print(error)
                            self.showAlert()
                        } else {
                            self.save(the: banks)
                            self.dataSource = banks
                            self.updateView(isLocalData: false)
                        }
                    }
                }
            }
        }
        
    }
    
    func updateView(isLocalData:Bool = true) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.descriptionlabel.text = isLocalData ? "Listo!, ahora estamos mostrando los datos consultados de la base de datos local de la app" : "Aqui hemos consultado el servicio y esta es la lista de bancos que nos ha respondido."
            self.infoLabel.text = isLocalData ? "" : " Si deseas ver la misma lista haciendo la consulta de la base de datos local, sal y vuelve a ingresar a esta pantalla.d"
        }
    }
    
    func fetchBankListService(completionHandler: @escaping(_ bankList:[BankModel], _ error:String?) -> Void) {
        if let url = URL(string: "https://api.myjson.com/bins/19e11s") {
            urlSession.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    completionHandler([],error.localizedDescription)
                } else {
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let banklist = try decoder.decode([BankModel].self, from: data)
                            completionHandler(banklist,nil)
                        }catch {
                            completionHandler([],error.localizedDescription)
                        }
                    } else {
                        completionHandler([],"Data is nill")
                    }
                }
            }.resume()
        }
    }
    
    func fetchLocalBankList(completionHandler: @escaping(_ bankList:[BankModel], _ error:String?) -> Void) {
        var bankList:[BankModel] = []
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context =
          appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Bank> = Bank.fetchRequest()
        
        do {
          let rawBanks = try context.fetch(fetchRequest)
            for rawBank in rawBanks {
                let bank = BankModel(name: rawBank.bank_name ?? "",
                                     description: rawBank.descript ?? "",
                                     age: Int(rawBank.age),
                                     url: rawBank.url ?? "")
                bankList.append(bank)
            }
            completionHandler(bankList,nil)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            completionHandler([],error.localizedDescription)
        }
    }
    
    func save(the bankList:[BankModel]) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let persistanceContainer = appDelegate.persistentContainer
            let context = persistanceContainer.viewContext
            
            let entity =
               NSEntityDescription.entity(forEntityName: "Bank",
                                          in: context)!
            
            for bankitem in bankList {
                let bank = NSManagedObject(entity: entity,
                insertInto: context)
                bank.setValue(bankitem.bankName, forKeyPath: "bank_name")
                bank.setValue(bankitem.description, forKeyPath: "descript")
                bank.setValue(bankitem.age, forKeyPath: "age")
                bank.setValue(bankitem.url, forKeyPath: "url")
            }
            
            do {
                try context.save()
            } catch {
                print("Algo salio mal al guardar los datos")
            }
        }
    }
    
    func showAlert(title:String? = nil, message:String? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title ?? "Oups!", message: message ?? "Algo salio mal!, intenta nuevamente", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            
            self.present(alert, animated: true)
        }
    }

}

extension BankListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankListCollectionViewCell", for: indexPath) as! BankListCollectionViewCell
        cell.bank = dataSource[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((self.collectionView.frame.width / 2) - 32)
        let height = (self.view.frame.height) / 3
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = ((self.collectionView.frame.width / 2) - 32)

        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        let edgeInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)

        return UIEdgeInsets(top: 15, left: edgeInsets, bottom: 0, right: edgeInsets)
    }
}
