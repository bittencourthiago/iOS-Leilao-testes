//
//  LeilaoDaoFalso.swift
//  Leilao
//
//  Created by Thiago Bittencourt Coelho on 06/01/21.
//  Copyright © 2021 Alura. All rights reserved.
//

import Foundation

class LeilaoDaoFalso {
    
    private var leiloes:[Leilao] = []
    
    func salva(_ leilao: Leilao) {
        
        leiloes.append(leilao)
    
    }
    func encerrados() -> [Leilao] {
        
        return leiloes.filter({ $0.encerrado == true })
    
    }
    func correntes() -> [Leilao] {
        return leiloes.filter({ $0.encerrado == false })
    }
    func atualiza(_ leilao: Leilao) {
        
    }
}
