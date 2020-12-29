//
//  Leilao.swift
//  Leilao
//
//  Created by Ândriu Coelho on 27/04/18.
//  Copyright © 2018 Alura. All rights reserved.
//

import Foundation

class Leilao {
    
    let descricao:String
    let imagem:String?
    var lances:[Lance]?
    
    init(descricao:String, imagem:String? = nil, lances:[Lance] = []) {
        self.descricao = descricao
        self.imagem = imagem
        self.lances = lances
    }
    
    func propoe(lance:Lance) {
        
        guard let listaDeLances = lances else { return }

        if listaDeLances.count == 0 || ultimoLance(listaDeLances).usuario != lance.usuario {
           
            lances?.append(lance)
            
        }
    }
    private func ultimoLance(_ lances:[Lance]) -> Lance {
        
        return lances[lances.count-1]
        
    }
    
}
