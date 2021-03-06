//
//  PreguntaEscalaViewCell.swift
//  Focus
//
//  Created by Eduardo Cristerna on 04/12/16.
//  Copyright © 2016 Eduardo Cristerna. All rights reserved.
//

import UIKit

class PreguntaEscalaViewCell: TableViewCell {

    @IBOutlet var tituloLabel: UILabel!
    @IBOutlet var tituloHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var videoButton: UIButton!
    @IBOutlet var videoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var videoBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var imagen: UIImageView!
    @IBOutlet var imagenHeightConstraint: NSLayoutConstraint!
    @IBOutlet var imagenBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var preguntaLabel: UILabel!
    
    @IBOutlet var responseLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    var pregunta: Pregunta?
    var videoHandler: Selector? {
        didSet {
            self.videoButton.addTarget(nil, action: videoHandler!, for: .touchUpInside)
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------
    // MARK: - Configure
    // -----------------------------------------------------------------------------------------------------------
    
    func configureForPregunta(_ numPregunta: Int) {
        guard let pregunta = self.pregunta else {
            return
        }
        
        self.tituloLabel.text = pregunta.titulo
        self.tituloHeightConstraint.constant = pregunta.titulo.isEmpty ? 0 : 60
        
        self.videoButton.tag = numPregunta
        
        self.videoHeightConstraint.constant = 0
        self.videoBottomConstraint.constant = 0
        self.imagenHeightConstraint.constant = 0
        self.imagenBottomConstraint.constant = 0
        
        if (!pregunta.video.isEmpty) {
            self.videoHeightConstraint.constant = 40
            self.videoBottomConstraint.constant = 15
        }
        
        if let image = pregunta.imagen {
            self.imagenHeightConstraint.constant = 200
            self.imagenBottomConstraint.constant = 15
            self.imagen.image = image
        }
        
        self.preguntaLabel.text = pregunta.pregunta
        
        self.stepper.minimumValue = pregunta.minScale
        self.stepper.maximumValue = pregunta.maxScale
        self.stepper.value = pregunta.respuesta.isEmpty ? 0 : Double(pregunta.respuesta)!
        
        self.responseLabel.text = pregunta.respuesta.isEmpty ? nil : pregunta.respuesta
    }

    @IBAction func stepperChanged(_ sender: UIStepper) {
        if (self.pregunta!.respuesta.isEmpty) {
            sender.value = sender.minimumValue
        }
        
        let value = Int(sender.value)
        
        self.pregunta?.respuesta = "\(value)"
        self.responseLabel.text = "\(value)"
    }
    
}
