//
//  AdminUsersTableTableViewController.swift
//  QuizApp-IOS
//
//  Created by Christopher Medina on 3/25/22.
//

import UIKit

protocol ChibiSelectionDelegate: AnyObject
{
    func ChibiSelected(_ NextChibi: Chirabi)
}

class AdminUsersTableTableViewController: UITableViewController {

    weak var delegate: ChibiSelectionDelegate?
    
    let Chibi =
    [
        Chirabi(Name: "Powder", BIO: "A Timid yet Prodigeous Chirabi", At: .Ragnarok),
        Chirabi(Name: "Asriel", BIO: "A Highly Skilled Chirabi", At: .Celestial),
        Chirabi(Name: "Kilo", BIO: "Leader of the Chirabi", At: .Hyper),
        Chirabi(Name: "Cataclysm", BIO: "An Interdimensional Warrior", At: .Cataclysm),
        Chirabi(Name: "Missero", BIO: "Founder of the AAK", At: .Hyper),
        Chirabi(Name: "Fortitude", BIO: "Strategic Genius", At: .Weapon),
        Chirabi(Name: "Ruby", BIO: "A Trainee with unparalleled Potential", At: .Chaos),
        Chirabi(Name: "Cinnamon", BIO: "Trainee with a unique take on life", At: .Emotion),
        Chirabi(Name: "Juno", BIO: "Trainee who's brilliant but lazy", At: .Force),
        Chirabi(Name: "Max", BIO: "Loner of a Trainee", At: .Aura)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Chibi.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        let chibi = Chibi[indexPath.row]
        cell.textLabel?.text = chibi.name
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedOption = Chibi[indexPath.row]
        delegate?.ChibiSelected(selectedOption)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
