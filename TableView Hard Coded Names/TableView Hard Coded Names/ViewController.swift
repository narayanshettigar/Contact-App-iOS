//
//  ViewController.swift
//  TableView Hard Coded Names
//
//  Created by Narayan on 26/05/23.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var tableVIEW: UITableView!

	var countries : [String] = ["Apple", "Ate", "Ace", "Ball", "Bat",
								"Cat", "Dog", "Elephant", "Fish", "Giraffe",
								"Horse", "Ink", "Jump", "Kite", "Lion",
								"Monkey", "Nest", "Octopus", "Pig", "Queen",
								"Rat", "Snake", "Tiger", "Umbrella", "Vase",
								"Whale", "X-ray", "Yarn", "Zebra"]


	@IBOutlet weak var txtfield: UITextField!


	@IBAction func addbtn(_ sender: Any)  {
		guard var name = txtfield.text, !name.isEmpty else {
			return
		}
		name = name.capitalized
		countries.append(name)
		countries.sort()
		updateCountryDictionary()
		tableVIEW.reloadData()

		txtfield.text = ""
	}

	func updateCountryDictionary() {
		sectionTitle = Array(Set(countries.compactMap({ String($0.prefix(1)) })))
		sectionTitle.sort()

		countryDict.removeAll()

		for firstLetter in sectionTitle {
			countryDict[firstLetter] = countries.filter { String($0.prefix(1)) == firstLetter }
		}
	}




	var sectionTitle = [String]()

	var countryDict = [String:[String]]()

	override func viewDidLoad() {
		super.viewDidLoad()
		sectionTitle = Array(Set(countries.compactMap({String($0.prefix(1))})))
		sectionTitle.sort()

		for firstLETTERtitle in sectionTitle {
			countryDict[firstLETTERtitle] = [String]()
		}

		for country in countries {
			let firstLetter = String(country.prefix(1))
			countryDict[firstLetter]?.append(country)
		}
	}


}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		countryDict[sectionTitle[section]]?.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = countryDict[sectionTitle[indexPath.section]]?[indexPath.row]
		return cell
	}
	func numberOfSections(in tableView: UITableView) -> Int {
		return sectionTitle.count
	}
	//side bar
	func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return sectionTitle
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return sectionTitle[section]
	}
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
//	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//		if editingStyle == .delete {
//			tableView.beginUpdates()
//			countries.remove(at: indexPath.row)
//			tableView.deleteRows(at: [indexPath], with: .fade)
//			updateCountryDictionary()
//			tableView.endUpdates()
//		}
//	}
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			tableView.beginUpdates()
			let sectionKey = sectionTitle[indexPath.section]
			if var sectionCountries = countryDict[sectionKey],
			   let country = sectionCountries[safe: indexPath.row] {
				sectionCountries.remove(at: indexPath.row)
				countryDict[sectionKey] = sectionCountries
				countries.removeAll { $0 == country }
				tableView.deleteRows(at: [indexPath], with: .fade)

					// Delete the whole section if it has only one element
				if sectionCountries.isEmpty {
					sectionTitle.remove(at: indexPath.section)
					tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
				}
				updateCountryDictionary()
			}
			tableView.endUpdates()
		}
	}

}

extension Array {
	subscript(safe index: Int) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
