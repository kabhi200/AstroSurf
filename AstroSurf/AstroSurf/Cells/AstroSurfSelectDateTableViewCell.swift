//
//  AstroSurfSelectDateTableViewCell.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 28/02/22.
//

import UIKit

public protocol AstroSurfSelectDateProtocol {
    func showDatePickerForDateSelection()
}

class AstroSurfSelectDateTableViewCell: UITableViewCell {

    @IBOutlet var selectedDateLabel: UILabel!
    @IBOutlet var selectDateButton: UIButton!

    var delegate: AstroSurfSelectDateProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// To update the UI of the table view cell
    /// - Parameter date: date selected by user
    func updateUI(date: String) {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.selectDateButton.setTitleColor(.white, for: .normal)
        }

        self.selectedDateLabel.text = date
    }
    
    
    /// select button action to open date picker
    /// - Parameter sender: selectDateButton
    @IBAction func selectDateButtonAction(_ sender: UIButton) {
        self.delegate?.showDatePickerForDateSelection()
    }
}
