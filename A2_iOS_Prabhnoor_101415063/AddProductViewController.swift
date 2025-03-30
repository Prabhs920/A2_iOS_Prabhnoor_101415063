//
//  AddProductViewController.swift
//  A2_iOS_Prabhnoor_101415063
//
//  Created by Prabhnoor on 26.03.25.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var providerField: UITextField!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addProduct(_ sender: UIButton) {
        guard let name = nameField.text, !name.isEmpty,
              let desc = descField.text, !desc.isEmpty,
              let priceText = priceField.text, let price = Double(priceText),
              let provider = providerField.text, !provider.isEmpty else {
            // Show error if needed
            return
        }

        let newProduct = Product(context: context)
        newProduct.id = UUID()
        newProduct.name = name
        newProduct.desc = desc
        newProduct.price = price
        newProduct.provider = provider

        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch {
            print("Failed to save product: \(error)")
        }
    }

    
}
