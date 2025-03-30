import UIKit
import CoreData

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var providerLabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var products: [Product] = []
    var currentIndex = 0

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchProducts()
        updateView()
        
        searchBar.delegate = self
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(doSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(doSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        
        [nameLabel, idLabel, descriptionLabel, priceLabel, providerLabel].forEach { label in
            label?.layer.cornerRadius = 10
            label?.layer.masksToBounds = true
            label?.backgroundColor = UIColor.white
            label?.textColor = UIColor.darkGray
            label?.textAlignment = .center
            label?.layer.borderColor = UIColor.systemGray4.cgColor
            label?.layer.borderWidth = 1.2
        }
        [prevButton, nextButton].forEach { button in
            button?.layer.cornerRadius = 12
            button?.setTitleColor(.white, for: .normal)
            button?.backgroundColor = UIColor.systemBlue
            button?.layer.shadowColor = UIColor.black.cgColor
            button?.layer.shadowOpacity = 0.3
            button?.layer.shadowRadius = 4
            button?.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
         
    }
    
    func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            products = try context.fetch(request)
        } catch {
            print("Failed to fetch products: \(error)")
        }
    }

    func updateView() {
        guard !products.isEmpty else { return }
        let product = products[currentIndex]
        nameLabel.text = product.name
        idLabel.text = product.id?.uuidString
        descriptionLabel.text = product.desc
        priceLabel.text = String(format: "$%.2f", product.price)
        providerLabel.text = product.provider
        
        prevButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < products.count - 1
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchProducts()
        } else {
            filterProducts(keyword: searchText)
        }
        currentIndex = 0
        updateView()
    }
   
    func filterProducts(keyword: String) {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "name CONTAINS[cd] %@", keyword),
            NSPredicate(format: "desc CONTAINS[cd] %@", keyword)
        ])
        
        do {
            products = try context.fetch(request)
        } catch {
            print("Failed to search products: \(error)")
        }
    }
    
    @objc func doSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if currentIndex < products.count - 1 {
                currentIndex += 1
                updateView()
            }
        } else if gesture.direction == .right {
            if currentIndex > 0 {
                currentIndex -= 1
                updateView()
            }
        }
    }

    @IBAction func prevTapped(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
            updateView()
        }
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        if currentIndex < products.count - 1 {
            currentIndex += 1
            updateView()
        }
    }
}
