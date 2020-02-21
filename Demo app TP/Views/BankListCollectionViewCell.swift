//
//  BankListCollectionViewCell.swift
//  Demo app TP
//
//  Created by Jonathan Pabel Saldivar Mendoza on 20/02/20.
//  Copyright © 2020 Jonathan Pabel Saldivar Mendoza. All rights reserved.
//

import UIKit

class BankListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var banknameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var bank:BankModel? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boxView.layer.cornerRadius = 12
        boxView.layer.masksToBounds = false
        boxView.layer.shadowColor = UIColor.black.cgColor
        boxView.layer.shadowOffset = CGSize(width: 0, height: 2)
        boxView.layer.shadowRadius = 3
        boxView.layer.shadowOpacity = 0.30
    }
    
    func configureCell() {
        if let bank = bank {
            banknameLabel.text = bank.bankName
            ageLabel.text = "\(bank.age)"
            descriptionLabel.text = bank.description
            
            if let url = URL(string: bank.url) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.contains("image"),
                        let data = data,
                        let image = UIImage(data: data)
                        else { return }
                    if let error = error {
                        print("Error al descargar la imagen \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                         self.imageView.image = image
                        }
                    }
                }.resume()
            }
        }
    }
    
}
