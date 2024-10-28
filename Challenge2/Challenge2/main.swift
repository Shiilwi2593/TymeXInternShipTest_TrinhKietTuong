//
//  main.swift
//  Challenge2
//
//  Created by Trịnh Kiết Tường on 28/10/24.
//


import Foundation

//MARK: - Question 2.1: PRODUCT INVENTORY MANAGEMENT
//Inventory
let inventories: [Product] = [
    Product(name: "Laptop", price: 999.99, quantity: 5),
    Product(name: "Smartphone", price: 499.99, quantity: 10),
    Product(name: "Tablet", price: 299.99, quantity: 0),
    Product(name: "Smartwatch", price: 199.99, quantity: 3),
    Product(name: "headphones", price: 012, quantity: 12)
]

//MARK: Calculate the total inventory value
func calculateInventoryValue(products: [Product]) -> Double {
    var totalValue = 0.0
    for product in products{
        totalValue += product.price * Double(product.quantity)
    }
    return totalValue
}
let totalValue = calculateInventoryValue(products: inventories)
print("Question 2.1.1: Total value of all product in stock: ", String(format: "%.2f", totalValue))


//MARK: Find the most expensive product
func findMostExpensiveProduct(products: [Product]) -> String{
    guard let mostExpensiveProduct = products.max(by: { $0.price < $1.price }) else {
        return "Question 2.1.1: No product available"
        
    }
    return mostExpensiveProduct.name
}
let mostExpensiveProduct = findMostExpensiveProduct(products: inventories)
print("Question 2.1.2: Most expensive product in stock: ", mostExpensiveProduct)


//MARK: Check if a product named "Headphones" is in stock
func checkProductExist(products: [Product], productName: String) -> Bool{
    return products.contains(where: { $0.name.lowercased() == productName.lowercased() })
}
let checkProduct = checkProductExist(products: inventories, productName: "Headphones")
print("Question 2.1.3: Is there any product name \"Headphones\" :", checkProduct)


//MARK: Sort products in descending/ascending order with options like by price, quantity
func sortProduct(products: [Product],by option: String, ascending: Bool) -> [Product] {
    switch option.lowercased() {
    case "price":
        return products.sorted{ ascending ? $0.price < $1.price : $0.price > $1.price }
    case "quantity":
        return products.sorted{ ascending ? $0.quantity < $1.quantity : $0.quantity > $1.quantity }
    default:
        print("Invalid option for sort")
        return products
    }
}

func displayProductList(products: [Product], sortedBy option: String, ascending: Bool) {
    print("------------------------------")
    print("Product list sorted by \(option) (\(ascending ? "Ascending" : "Descending")):")
    for product in products {
        let value = option == "price" ? "\(product.price)" : "\(product.quantity)"
        print("Name: \(product.name), \(option.capitalized): \(value)")
    }
    print("\n")
}

// Sort By Price
print("Question 2.1.4:")
let sortByPriceAscending = sortProduct(products: inventories, by: "price", ascending: true)
let sortByPriceDescending = sortProduct(products: inventories, by: "price", ascending: false)

displayProductList(products: sortByPriceAscending, sortedBy: "price", ascending: true)
displayProductList(products: sortByPriceDescending, sortedBy: "price", ascending: false)

// Sort By Quantity
let sortByQuantityAscending = sortProduct(products: inventories, by: "quantity", ascending: true)
let sortByQuantityDescending = sortProduct(products: inventories, by: "quantity", ascending: false)

displayProductList(products: sortByQuantityAscending, sortedBy: "quantity", ascending: true)
displayProductList(products: sortByQuantityDescending, sortedBy: "quantity", ascending: false)



//MARK: - Question 2.2: Array manipulation and Missing Number Problem
let input = [3,7,1,2,6,4]

//Get min and max of array
let min = input.min()
let max = input.max()
//Create ascending array
let ascendingArr = Array(min!...max!)

//Find missing number between AscendingArr and array
for number in ascendingArr{
    if !input.contains(number){
        print("Question 2.2: Missing number: \(number)")
    }
}



//MARK: -Console result
//Question 2.1.1: Total value of all product in stock:  10743.82
//Question 2.1.2: Most expensive product in stock:  Laptop
//Question 2.1.3: Is there any product name "Headphones" : true
//Question 2.1.4:
//------------------------------
//Product list sorted by price (Ascending):
//Name: headphones, Price: 12.0
//Name: Smartwatch, Price: 199.99
//Name: Tablet, Price: 299.99
//Name: Smartphone, Price: 499.99
//Name: Laptop, Price: 999.99
//
//
//------------------------------
//Product list sorted by price (Descending):
//Name: Laptop, Price: 999.99
//Name: Smartphone, Price: 499.99
//Name: Tablet, Price: 299.99
//Name: Smartwatch, Price: 199.99
//Name: headphones, Price: 12.0
//
//
//------------------------------
//Product list sorted by quantity (Ascending):
//Name: Tablet, Quantity: 0
//Name: Smartwatch, Quantity: 3
//Name: Laptop, Quantity: 5
//Name: Smartphone, Quantity: 10
//Name: headphones, Quantity: 12
//
//
//------------------------------
//Product list sorted by quantity (Descending):
//Name: headphones, Quantity: 12
//Name: Smartphone, Quantity: 10
//Name: Laptop, Quantity: 5
//Name: Smartwatch, Quantity: 3
//Name: Tablet, Quantity: 0
//
//
//Question 2.2: Missing number: 5
//Program ended with exit code: 0
