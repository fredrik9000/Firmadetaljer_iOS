//
//  CompanyParserUtil.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 08/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import Foundation

class CompanyUtil {
    
    static func populateCompany(_ data:[String:AnyObject]) -> Company {
        let company = Company()
        company.navn = data["navn"] as? String ?? nil
        company.organisasjonsnummer = data["organisasjonsnummer"] as? Int ?? nil
        company.stiftelsesdato = data["stiftelsesdato"] as? String ?? nil
        company.registreringsdatoEnhetsregisteret = data["registreringsdatoEnhetsregisteret"] as? String ?? nil
        company.oppstartsdato = data["oppstartsdato"] as? String ?? nil
        company.datoEierskifte = data["datoEierskifte"] as? String ?? nil
        company.organisasjonsform = data["organisasjonsform"] as? String ?? nil
        company.hjemmeside = data["hjemmeside"] as? String ?? nil
        company.registrertIFrivillighetsregisteret = data["registrertIFrivillighetsregisteret"] as? String ?? nil
        company.registrertIMvaregisteret = data["registrertIMvaregisteret"] as? String ?? nil
        company.registrertIForetaksregisteret = data["registrertIForetaksregisteret"] as? String ?? nil
        company.registrertIStiftelsesregisteret = data["registrertIStiftelsesregisteret"] as? String ?? nil
        company.frivilligRegistrertIMvaregisteret = data["frivilligRegistrertIMvaregisteret"] as? String ?? nil
        company.antallAnsatte = data["antallAnsatte"] as? Int ?? nil
        company.sisteInnsendteAarsregnskap = data["sisteInnsendteAarsregnskap"] as? Int ?? nil
        company.konkurs = data["konkurs"] as? String ?? nil
        company.underAvvikling = data["underAvvikling"] as? String ?? nil
        company.underTvangsavviklingEllerTvangsopplosning = data["underTvangsavviklingEllerTvangsopplosning"] as? String ?? nil
        company.overordnetEnhet = data["overordnetEnhet"] as? Int ?? nil
        
        if let institusjonellSektorkode = data["institusjonellSektorkode"] as? Dictionary<String, AnyObject> {
            company.institusjonellSektorkode?.kode = institusjonellSektorkode["kode"] as? Int ?? nil
            company.institusjonellSektorkode?.beskrivelse = institusjonellSektorkode["beskrivelse"] as? String ?? nil
        }
        
        if let naeringskode1 = data["naeringskode1"] as? Dictionary<String, String> {
            company.naeringskode1 = Naeringskode()
            populateNaeringskode(company.naeringskode1!, data: naeringskode1)
        }
        
        if let naeringskode2 = data["naeringskode2"] as? Dictionary<String, String> {
            company.naeringskode2 = Naeringskode()
            populateNaeringskode(company.naeringskode2!, data: naeringskode2)
        }
        
        if let naeringskode3 = data["naeringskode3"] as? Dictionary<String, String> {
            company.naeringskode3 = Naeringskode()
            populateNaeringskode(company.naeringskode3!, data: naeringskode3)
        }
        
        if let postadresse = data["postadresse"] as? Dictionary<String, AnyObject> {
            company.postadresse = Adresse()
            populateAddress(company.postadresse!, addressData: postadresse)
        }
        
        if let forretningsadresse = data["forretningsadresse"] as? Dictionary<String, AnyObject> {
            company.forretningsadresse = Adresse()
            populateAddress(company.forretningsadresse!, addressData: forretningsadresse)
        }
        
        if let beliggenhetsadresse = data["beliggenhetsadresse"] as? Dictionary<String, AnyObject> {
            company.beliggenhetsadresse = Adresse()
            populateAddress(company.beliggenhetsadresse!, addressData: beliggenhetsadresse)
        }
        
        return company
    }
    
    static private func populateNaeringskode(_ companyNaeringskode:Naeringskode, data:Dictionary<String, String>) {
        companyNaeringskode.kode = data["kode"]
        companyNaeringskode.beskrivelse = data["beskrivelse"]
    }
    
    static private func populateAddress(_ companyAddress:Adresse, addressData:Dictionary<String, AnyObject>) {
        companyAddress.postnummer = addressData["postnummer"] as? Int ?? nil
        companyAddress.adresse = addressData["adresse"] as? String ?? nil
        companyAddress.poststed = addressData["poststed"] as? String ?? nil
        companyAddress.kommunenummer = addressData["kommunenummer"] as? Int ?? nil
        companyAddress.kommune = addressData["kommune"] as? String ?? nil
        companyAddress.landkode = addressData["landkode"] as? String ?? nil
        companyAddress.land = addressData["land"] as? String ?? nil
    }
    
}
