//
//  ProfileViewController.swift
//  Focus
//
//  Created by Eduardo Cristerna on 30/07/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit
import MessageUI

enum Sections: Int {
    case User
    case Panels
    case Contact
    case LogOut
}

class ProfileViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var panelsLabel: UILabel!
    @IBOutlet var encuestasLabel: UILabel!
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Lifecycle
    // -----------------------------------------------------------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        guard let user = User.currentUser, paneles = self.appDelegate.paneles else {
            return
        }
        
        var pending = 0
        
        for panel in paneles {
            pending += panel.encuestasPendientes
        }
        
        self.nameLabel.text = user.nombre
        self.emailLabel.text = user.email
        self.panelsLabel.text = "\(paneles.count)"
        self.encuestasLabel.text = "\(pending)"
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Navigation
    // -----------------------------------------------------------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if (segue.identifier == "logOut") {
            NSUserDefaults.removeUserDefaults()
            self.appDelegate.user = nil
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - TableView
    // -----------------------------------------------------------------------------------------------------------
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch Sections(rawValue: indexPath.section)! {
        case .Contact:
            if (indexPath.row == 0) {
                self.sendEmail()
            } else if (indexPath.row == 1) {
                self.call()
            }
            
            return
        case .LogOut:
            func firstBlock(action: UIAlertAction) {
                Controller.requestForAction(.UNREGISTER_DEVICE, withParameters: ["id" : User.currentUser!.id], withSuccessHandler: nil, andErrorHandler: nil)
                self.performSegueWithIdentifier("logOut", sender: nil)
            }
            
            self.presentAlertWithTitle("Cerrar Sesión", withMessage: "La próxima vez que abra la aplicación se le pedirán sus datos de acceso.", withButtonTitles: ["Cerrar", "Cancelar"], withButtonStyles: [.Destructive, .Cancel], andButtonHandlers: [firstBlock, nil])
            
            return
        default:
            return
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Helpers
    // -----------------------------------------------------------------------------------------------------------
    
    func call() {
        if let phoneURL: NSURL = NSURL(string: "tel://\(phoneNumber)") {
            if (UIApplication.sharedApplication().canOpenURL(phoneURL)) {
                UIApplication.sharedApplication().openURL(phoneURL)
            }
        }
    }
    
    func sendEmail() {
        let mailComposeViewController = self.mailComposerViewController()
        
        if (MFMailComposeViewController.canSendMail()) {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        self.presentAlertWithTitle("Error", withMessage: "Su dispositivo parece no estar configurado para enviar correo.", withButtonTitles: ["OK"], withButtonStyles: [.Cancel], andButtonHandlers: [nil])
    }
    
    func mailComposerViewController() -> MFMailComposeViewController {
        let mailComposerViewController = MFMailComposeViewController()
        
        mailComposerViewController.mailComposeDelegate = self
        mailComposerViewController.setToRecipients([email])
        mailComposerViewController.setSubject("")
        mailComposerViewController.setMessageBody("", isHTML: false)
        
        return mailComposerViewController
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - MFMailComposeViewControllerDelegate
    // -----------------------------------------------------------------------------------------------------------
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
