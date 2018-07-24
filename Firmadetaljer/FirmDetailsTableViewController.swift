//
//  FirmDetailsTableViewController.swift
//  Firmadetaljer
//
//  Created by Fredrik Eilertsen on 06/05/16.
//  Copyright © 2016 Fredrik Eilertsen. All rights reserved.
//

import UIKit

class FirmDetailsTableViewController: UITableViewController {
    
    private struct SectionCellData {
        var cells = [UITableViewCell]()
        var header:String
        
        init (header:String) {
            self.header = header
        }
    }
    
    var company: Company?
    private var sections = [SectionCellData]()
    
    private func buildCell(_ name:String, description:String) -> UITableViewCell {
        let cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = description
        return cell
    }
    
    private func buildNaeringskodeCells(_ companyNaeringskode:Naeringskode) -> [UITableViewCell] {
        var naeringskodeCellsArray = Array<UITableViewCell>()
        
        if let kode = companyNaeringskode.kode {
            naeringskodeCellsArray.append(buildCell("Kode", description: kode))
        }
        if let beskrivelse = companyNaeringskode.beskrivelse {
            naeringskodeCellsArray.append(buildCell("Beskrivelse", description: beskrivelse))
        }
        
        return naeringskodeCellsArray
    }
    
    private func buildAdressCells(_ companyAddress:Adresse) -> [UITableViewCell] {
        var addressCellsArray = Array<UITableViewCell>()
        
        if let adresse = companyAddress.adresse {
            addressCellsArray.append(buildCell("Adresse", description: adresse))
        }
        if let postnummer = companyAddress.postnummer {
            addressCellsArray.append(buildCell("Postnummer", description: String(postnummer)))
        }
        if let poststed = companyAddress.poststed {
            addressCellsArray.append(buildCell("Poststed", description: poststed))
        }
        if let kommunenummer = companyAddress.kommunenummer {
            addressCellsArray.append(buildCell("Kommunenummer", description: String(kommunenummer)))
        }
        if let kommune = companyAddress.kommune {
            addressCellsArray.append(buildCell("Kommune", description: kommune))
        }
        if let landkode = companyAddress.landkode {
            addressCellsArray.append(buildCell("Landkode", description: landkode))
        }
        if let land = companyAddress.land {
            addressCellsArray.append(buildCell("Land", description: land))
        }
        
        return addressCellsArray
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.title = "Firmadetaljer"
        var mainSection = SectionCellData(header: "Detaljer")
        
        if let navn = company?.navn {
            mainSection.cells.append(buildCell("Firmanavn", description: navn))
        }
        
        if let orgnr = company?.organisasjonsnummer {
            mainSection.cells.append(buildCell("Organisasjonsnummer", description: String(orgnr)))
        }
        
        if let stiftelsesdato = company?.stiftelsesdato {
            mainSection.cells.append(buildCell("Stiftelsesdato", description: stiftelsesdato))
        }
        
        if let registreringsdatoEnhetsregisteret = company?.registreringsdatoEnhetsregisteret {
            mainSection.cells.append(buildCell("Registrert i enhetsregisteret", description: registreringsdatoEnhetsregisteret))
        }
        
        if let oppstartsdato = company?.oppstartsdato {
            mainSection.cells.append(buildCell("Oppstartsdato", description: oppstartsdato))
        }
        
        if let datoEierskifte = company?.datoEierskifte {
            mainSection.cells.append(buildCell("Eierskiftedato", description: datoEierskifte))
        }
        
        if let organisasjonsform = company?.organisasjonsform {
            mainSection.cells.append(buildCell("Organisasjonsform", description: organisasjonsform))
        }
        
        if let hjemmeside = company?.hjemmeside {
            let hjemmesideCell = buildCell("Hjemmeside", description: hjemmeside)
            hjemmesideCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            mainSection.cells.append(hjemmesideCell)
        }
        
        if let registrertIFrivillighetsregisteret = company?.registrertIFrivillighetsregisteret {
            mainSection.cells.append(buildCell("Registrert i frivillighetsregisteret", description: registrertIFrivillighetsregisteret))
        }
        
        if let registrertIMvaregisteret = company?.registrertIMvaregisteret {
            mainSection.cells.append(buildCell("Registrert i Mvaregisteret", description: registrertIMvaregisteret))
        }
        
        if let registrertIForetaksregisteret = company?.registrertIForetaksregisteret {
            mainSection.cells.append(buildCell("Registrert i foretaksregisteret", description: registrertIForetaksregisteret))
        }
        
        if let registrertIStiftelsesregisteret = company?.registrertIStiftelsesregisteret {
            mainSection.cells.append(buildCell("Registrert i stiftelsesregisteret", description: registrertIStiftelsesregisteret))
        }
        
        if let frivilligRegistrertIMvaregisteret = company?.frivilligRegistrertIMvaregisteret {
            mainSection.cells.append(buildCell("Frivillig registrert i Mvaregisteret", description: frivilligRegistrertIMvaregisteret))
        }
        
        if let antallAnsatte = company?.antallAnsatte {
            mainSection.cells.append(buildCell("Antall ansatte", description: String(antallAnsatte)))
        }
        
        if let sisteInnsendteAarsregnskap = company?.sisteInnsendteAarsregnskap {
            mainSection.cells.append(buildCell("Siste innsendte årsregnskap", description: String(sisteInnsendteAarsregnskap)))
        }
        
        if let konkurs = company?.konkurs {
            mainSection.cells.append(buildCell("Konkurs", description: konkurs))
        }
        
        if let underAvvikling = company?.underAvvikling {
            mainSection.cells.append(buildCell("Under avvikling", description: underAvvikling))
        }
        
        if let underTvangsavviklingEllerTvangsopplosning = company?.underTvangsavviklingEllerTvangsopplosning {
            mainSection.cells.append(buildCell("Under tvangsavvikling/tvangsoppløsning", description: underTvangsavviklingEllerTvangsopplosning))
        }
        
        if let overordnetEnhet = company?.overordnetEnhet {
            let overordnetEnhetCell = buildCell("Overordnet enhet", description: String(overordnetEnhet))
            overordnetEnhetCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            mainSection.cells.append(overordnetEnhetCell)
        }
        
        sections.append(mainSection)
        
        if let institusjonellSektorkode = company?.institusjonellSektorkode {
            var sektorkodeSection = SectionCellData(header: "Institusjonell sektorkode")
            
            if let kode = institusjonellSektorkode.kode {
                sektorkodeSection.cells.append(buildCell("Kode", description: String(kode)))
            }
            
            if let beskrivelse = institusjonellSektorkode.beskrivelse {
                sektorkodeSection.cells.append(buildCell("Beskrivelse", description: beskrivelse))
            }
            
            sections.append(sektorkodeSection)
        }
        
        if let naeringskode1 = company?.naeringskode1 {
            var naeringskode1Section = SectionCellData(header: "Næringskode 1")
            naeringskode1Section.cells = buildNaeringskodeCells(naeringskode1)
            sections.append(naeringskode1Section)
        }
        
        if let naeringskode2 = company?.naeringskode2 {
            var naeringskode2Section = SectionCellData(header: "Næringskode 2")
            naeringskode2Section.cells = buildNaeringskodeCells(naeringskode2)
            sections.append(naeringskode2Section)
        }
        
        if let naeringskode3 = company?.naeringskode3 {
            var naeringskode3Section = SectionCellData(header: "Næringskode 3")
            naeringskode3Section.cells = buildNaeringskodeCells(naeringskode3)
            sections.append(naeringskode3Section)
        }
        
        if let postadresse = company?.postadresse {
            var postadresseSection = SectionCellData(header: "Postadresse")
            postadresseSection.cells = buildAdressCells(postadresse)
            sections.append(postadresseSection)
        }
        
        if let forretningsadresse = company?.forretningsadresse {
            var forretningsadresseSection = SectionCellData(header: "Forretningsadresse")
            forretningsadresseSection.cells = buildAdressCells(forretningsadresse)
            sections.append(forretningsadresseSection)
        }
        
        if let beliggenhetsadresse = company?.beliggenhetsadresse {
            var beliggenhetsadresseSection = SectionCellData(header: "Beliggenhetsadresse")
            beliggenhetsadresseSection.cells = buildAdressCells(beliggenhetsadresse)
            sections.append(beliggenhetsadresseSection)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if company != nil {
            return sections.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].cells.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return sections[indexPath.section].cells[indexPath.row]
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].header
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellText = sections[indexPath.section].cells[indexPath.row].textLabel?.text {
            if cellText == "Hjemmeside" {
                self.performSegue(withIdentifier: "showWebView", sender: self)
            } else if cellText == "Overordnet enhet" {
                showParentCompany(company!.overordnetEnhet!)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWebView" {
            let webViewController = segue.destination as! WebViewController
            
            let hjemmeside = company!.hjemmeside!
            let range = hjemmeside.startIndex..<hjemmeside.index(hjemmeside.startIndex, offsetBy: 4)
            let substring = hjemmeside[range]
            if substring != "http" {
                webViewController.urlString = "http://" + hjemmeside
            } else {
                webViewController.urlString = hjemmeside
            }
        }
    }
    
    private func showParentCompany(_ organisasjonsnummer: Int) {
        guard let encodedURL = "http://data.brreg.no/enhetsregisteret/enhet/\(organisasjonsnummer).json".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {
            print("Couldn't encode URL"); return
        }
        JSONUtil.retrieveCompany(encodedURL) { self.companyParsed($0) }
    }
    
    private func companyParsed(_ company: Company?) {
        if let comp = company {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FirmDetailsController") as! FirmDetailsTableViewController
            vc.company = comp
            self.navigationController?.pushViewController(vc, animated: true)
        }  else {
            let alert = UIAlertController(title: "Error loading data", message: "Couldn't retrieve data. Do you have an internet connection?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
