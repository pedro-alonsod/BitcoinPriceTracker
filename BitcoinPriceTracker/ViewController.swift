//
//  ViewController.swift
//  BitcoinPriceTracker
//
//  Created by Pedro Alonso on 6/28/18.
//  Copyright © 2018 Pedro Alonso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var apiURL = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR"
    
    @IBOutlet weak var lbBitcoinUSD: UILabel!
    @IBOutlet weak var lbBitcoinEUR: UILabel!
    @IBOutlet weak var lbBitcoinJPY: UILabel!
    
    var refreshTimer: Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        UserDefaults.standard.set(123.56, forKey: "USD")
//        UserDefaults.standard.set(123.56, forKey: "EUR")
//        UserDefaults.standard.set(123.56, forKey: "JPY")
//        UserDefaults.standard.synchronize()
        getDefaultPrices()
        getPrice(url: apiURL)
    }

    func getDefaultPrices() {
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        let eurPrice = UserDefaults.standard.double(forKey: "EUR")
        let jpyPrice = UserDefaults.standard.double(forKey: "JPY")

        if usdPrice != 0.0 {
            self.lbBitcoinUSD.text = doubleToMoneyString(price: usdPrice, currencyCode: "USD") + "~"
//            self.lbBitcoinEUR.text = doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
//            self.lbBitcoinJPY.text = doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
        }
        
        if eurPrice != 0.0 {
//            self.lbBitcoinUSD.text = doubleToMoneyString(price: usdPrice, currencyCode: "USD")
            self.lbBitcoinEUR.text = doubleToMoneyString(price: eurPrice, currencyCode: "EUR") + "~"
//            self.lbBitcoinJPY.text = doubleToMoneyString(price: jpyPrice, currencyCode: "JPY")
        }
        
        if jpyPrice != 0.0 {
//            self.lbBitcoinUSD.text = doubleToMoneyString(price: usdPrice, currencyCode: "USD")
//            self.lbBitcoinEUR.text = doubleToMoneyString(price: eurPrice, currencyCode: "EUR")
            self.lbBitcoinJPY.text = doubleToMoneyString(price: jpyPrice, currencyCode: "JPY") + "~"
        }

    }

    func getPrice(url: String) {
        if let url = URL(string: url) {
            URLSession.shared.dataTask(with: url) { (json, response, error) in
                if let data = json {
                    print(data, "Got data")
                    
                    if let btcJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        print(btcJson, "json?")
                        
                        if let jsonDictionary = btcJson {
                            print(jsonDictionary)
                            
                            DispatchQueue.main.async {
                                
                                if let usd = jsonDictionary["USD"], let eur = jsonDictionary["EUR"], let jpy =  jsonDictionary["JPY"] {
                                    
                                    UserDefaults.standard.set(usd, forKey: "USD")
                                    UserDefaults.standard.set(eur, forKey: "EUR")
                                    UserDefaults.standard.set(jpy, forKey: "JPY")
                                    UserDefaults.standard.synchronize()
                                    
                                    self.lbBitcoinUSD.text = self.doubleToMoneyString(price: usd, currencyCode: "USD")//"$\(numFor.string(from: NSNumber(value: usd)))"
                                    self.lbBitcoinEUR.text = self.doubleToMoneyString(price: eur, currencyCode: "EUR") //"€\(numFor.string(from: NSNumber(value: eur)))"
                                    self.lbBitcoinJPY.text = self.doubleToMoneyString(price: jpy, currencyCode: "JPY")//"¥\(numFor.string(from: NSNumber(value: jpy)))"
                                }
                            }
                        }
//                        print(btcJson["EUR"], btcJson["JPY"], btcJson["EUR"])
                    }
                } else {
                    print(error)
                }
            }.resume()
        }
    }
    
    func doubleToMoneyString(price: Double, currencyCode: String) -> String {
        let numFor = NumberFormatter()
        numFor.numberStyle = .currency
        numFor.currencyCode = currencyCode
        
        if numFor.string(from: NSNumber(value: price)) == nil {
            return "Error"
        } else {
            return numFor.string(from: NSNumber(value: price))!
        }
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        getPrice(url: apiURL)
    }
    
}


