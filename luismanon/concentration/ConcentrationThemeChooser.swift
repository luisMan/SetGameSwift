//
//  ConcentrationThemeChooser.swift
//  luismanon
//
//  Created by Braulio Manon on 11/28/18.
//  Copyright © 2018 student. All rights reserved.
//


import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    let themes = [
        "Sports"   : "🌨✲🐼❄️⛸⛷☃️🍭⛄️",
        "forest"  : "🐶🐱🐭🦊🦁🐸🐔🦑🕷🐙🐖",
        "faces"    : "😀😙😛🤣😇😎😡🤡👹🤠",
        ]
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let button = sender as? UIButton {
                if let theme = button.currentTitle {
                    if let theme = themes[theme] {
                        cvc.theme = theme
                    }
                }
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let button = sender as? UIButton {
                if let theme = button.currentTitle {
                    if let theme = themes[theme] {
                        cvc.theme = theme
                    }
                }
            }
            navigationController?.pushViewController(cvc,
                                                     animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var lastSeguedToConcentrationViewController: concViewController?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton {
                if let themeName = button.currentTitle {
                    if let theme = themes[themeName] {
                        if let cvc = segue.destination as? concViewController {
                            cvc.theme = theme
                            lastSeguedToConcentrationViewController = cvc
                        }
                    }
                }
            }
        }
    }
    
    
    private var splitViewDetailConcentrationViewController: concViewController? {
        return splitViewController?.viewControllers.last as? concViewController
    }
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? concViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
}
