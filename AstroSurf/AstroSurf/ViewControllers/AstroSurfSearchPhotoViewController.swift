//
//  ViewController.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit

class AstroSurfSearchPhotoViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var headerLabel: UILabel!

    let selectDateCellReuseIdentifier = "SelectDate"
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  AstroSurfPhotoDetailViewModel.shared.isFavouriteSelected {
            if AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoCount() != 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    
    /// To update the ui of home screen
    func updateUI() {
        self.title = "Home"
        self.activityIndicator.isHidden = true
        self.datePicker.maximumDate = Date()
        AstroSurfPhotoDetailViewModel.shared.photoDetailDelegate = self
        self.tableView.register(UINib(nibName: "AstroSurfSelectDateTableViewCell", bundle: AstroSurfPhotoDetailViewModel.shared.bundle), forCellReuseIdentifier: selectDateCellReuseIdentifier)
        
      }
        
    
    /// To dismiss the picker view and toolbar
    /// - Parameter sender: done button
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        self.selectedDate = AstroSurfPhotoDetailViewModel.shared.getDateString(selectedDate: self.datePicker.date)
        self.datePicker.isHidden = true
        self.toolBar.isHidden = true
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight || (UIScreen.main.bounds.width > UIScreen.main.bounds.height) {
            self.headerLabel.frame = CGRect.init(x: self.headerLabel.frame.origin.x, y: self.headerLabel.frame.origin.y + 250, width: self.headerLabel.frame.size.width, height: self.headerLabel.frame.size.height)
            self.tableView.frame = CGRect.init(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y + 250, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        }

        self.tableView.reloadData()
    }
}

extension AstroSurfSearchPhotoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CellIdentifier")
        }
        if self.traitCollection.userInterfaceStyle == .dark {
            cell?.textLabel?.backgroundColor = .white
            cell?.textLabel?.textColor = .black
        }
        
        if indexPath.row == 0 {
            cell!.textLabel?.text = "Select to check Today's Astronomer Photo"
            return cell!
        } else if indexPath.row == 1 {
            let selectDateCell = tableView.dequeueReusableCell(withIdentifier: selectDateCellReuseIdentifier, for: indexPath) as! AstroSurfSelectDateTableViewCell
            selectDateCell.delegate = self
            selectDateCell.updateUI(date: selectedDate)
            return selectDateCell
        } else {
            cell!.textLabel?.isEnabled = (AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoCount() != 0) ? true : false
            cell!.textLabel?.text = (AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoCount() != 0) ? "Select to check the Favourites" : "Please add image to Favourite"
                
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let todayDate = AstroSurfPhotoDetailViewModel.shared.getDateString(selectedDate: Date())
            self.getPhotoDetailForDate(date: todayDate)
        } else if indexPath.row == 1 {
            self.getPhotoDetailForDate(date: self.selectedDate)
        } else {
            if AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoCount() != 0 {
                self.showFavourites()
            }
        }
    }
    
    
    /// To get photo detail of the selected date
    /// - Parameter date: selected date
    func getPhotoDetailForDate(date: String) {
        DispatchQueue.main.async { [self] in
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        AstroSurfPhotoDetailViewModel.shared.getPhotoDetailforDate(selectedDate: date)
    }
}

extension AstroSurfSearchPhotoViewController: AstroSurfPhtoDetailProtocol {
    
    
    /// Protocol method to show the photo detail
    func showPhotoDetail() {

        DispatchQueue.main.async { [self] in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true

            let photoViewController = AstroSurfPhotoDetailViewModel.shared.storyboard.instantiateViewController(withIdentifier: "SelectedPhoto") as! AstroSurfSelectedPhotoViewController
            self.navigationController?.pushViewController(photoViewController, animated: true)
        }
    }
    
    
    /// Protocol method to show the error popup
    /// - Parameters:
    ///   - errorTitle: title of the error
    ///   - errorMessage: error message
    func showErrorPopup(errorTitle: String, errorMessage: String) {
        DispatchQueue.main.async { [self] in
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            
            let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    /// To show Favourite photo details
    func showFavourites() {
        DispatchQueue.main.async { [self] in
            let photoViewController = AstroSurfPhotoDetailViewModel.shared.storyboard.instantiateViewController(withIdentifier: "Favourites") as! AstroSurfFavouritesViewController
            self.navigationController?.pushViewController(photoViewController, animated: true)
        }

    }
}

extension AstroSurfSearchPhotoViewController: AstroSurfSelectDateProtocol {
    
    
    /// To show Date picker for date selection
    func showDatePickerForDateSelection() {
        self.datePicker.isHidden = false
        self.toolBar.isHidden = false
        if (UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight) || (UIScreen.main.bounds.width > UIScreen.main.bounds.height) {
            self.headerLabel.frame = CGRect.init(x: self.headerLabel.frame.origin.x, y: self.headerLabel.frame.origin.y - 250, width: self.headerLabel.frame.size.width, height: self.headerLabel.frame.size.height)
            self.tableView.frame = CGRect.init(x: self.tableView.frame.origin.x, y: self.tableView.frame.origin.y - 250, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        }
    }
}
