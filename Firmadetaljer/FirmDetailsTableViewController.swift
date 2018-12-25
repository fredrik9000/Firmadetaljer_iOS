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
    
    private func buildNonInteractiveCell(_ name:String, description:String) -> UITableViewCell {
        let cell = buildCell(name, description: description)
        cell.isUserInteractionEnabled = false
        return cell
    }
    
    private func buildNaeringskodeCells(_ companyNaeringskode:Naeringskode) -> [UITableViewCell] {
        var naeringskodeCellsArray = Array<UITableViewCell>()
        
        if let kode = companyNaeringskode.kode {
            naeringskodeCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Naeringskode-Code", comment: ""), description: kode))
        }
        if let beskrivelse = companyNaeringskode.beskrivelse {
            naeringskodeCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Naeringskode-Description", comment: ""), description: beskrivelse))
        }
        
        return naeringskodeCellsArray
    }
    
    private func buildAdressCells(_ companyAddress:Adresse) -> [UITableViewCell] {
        var addressCellsArray = Array<UITableViewCell>()
        
        if let adresse = companyAddress.adresse {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-Address", comment: ""), description: adresse))
        }
        if let postnummer = companyAddress.postnummer {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-ZipCode", comment: ""), description: String(postnummer)))
        }
        if let poststed = companyAddress.poststed {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-City", comment: ""), description: poststed))
        }
        if let kommunenummer = companyAddress.kommunenummer {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-MunicipalityNumber", comment: ""), description: String(kommunenummer)))
        }
        if let kommune = companyAddress.kommune {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-Municipal", comment: ""), description: kommune))
        }
        if let landkode = companyAddress.landkode {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-CountryCode", comment: ""), description: landkode))
        }
        if let land = companyAddress.land {
            addressCellsArray.append(buildNonInteractiveCell(NSLocalizedString("Adresse-Country", comment: ""), description: land))
        }
        
        return addressCellsArray
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        var mainSection = SectionCellData(header: NSLocalizedString("Detail-Section", comment: ""))
        
        if let navn = company?.navn {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-FirmName", comment: ""), description: navn))
            self.title = navn
        }
        
        if let orgnr = company?.organisasjonsnummer {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Org.number", comment: ""), description: String(orgnr)))
        }
        
        if let stiftelsesdato = company?.stiftelsesdato {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-DateOfEstablishment", comment: ""), description: stiftelsesdato))
        }
        
        if let registreringsdatoEnhetsregisteret = company?.registreringsdatoEnhetsregisteret {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Enhetsregisteret", comment: ""), description: decodeYesOrNo(registreringsdatoEnhetsregisteret)))
        }
        
        if let oppstartsdato = company?.oppstartsdato {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-StartingDate", comment: ""), description: oppstartsdato))
        }
        
        if let datoEierskifte = company?.datoEierskifte {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-ChangeOfOwnershipDate", comment: ""), description: datoEierskifte))
        }
        
        if let organisasjonsform = company?.organisasjonsform {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-OrganizationalForm", comment: ""), description: organisasjonsform))
        }
        
        if let hjemmeside = company?.hjemmeside {
            let hjemmesideCell = buildCell(NSLocalizedString("Detail-Website", comment: ""), description: hjemmeside)
            hjemmesideCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            mainSection.cells.append(hjemmesideCell)
        }
        
        if let registrertIFrivillighetsregisteret = company?.registrertIFrivillighetsregisteret {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Frivillighetsregisteret", comment: ""), description: decodeYesOrNo(registrertIFrivillighetsregisteret)))
        }
        
        if let registrertIMvaregisteret = company?.registrertIMvaregisteret {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Mvaregisteret", comment: ""), description: decodeYesOrNo(registrertIMvaregisteret)))
        }
        
        if let registrertIForetaksregisteret = company?.registrertIForetaksregisteret {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Foretaksregisteret", comment: ""), description: decodeYesOrNo(registrertIForetaksregisteret)))
        }
        
        if let registrertIStiftelsesregisteret = company?.registrertIStiftelsesregisteret {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Stiftelsesregisteret", comment: ""), description: decodeYesOrNo(registrertIStiftelsesregisteret)))
        }
        
        if let frivilligRegistrertIMvaregisteret = company?.frivilligRegistrertIMvaregisteret {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Mvaregisteret-Voluntarily", comment: ""), description: decodeYesOrNo(frivilligRegistrertIMvaregisteret)))
        }
        
        if let antallAnsatte = company?.antallAnsatte {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Employees", comment: ""), description: String(antallAnsatte)))
        }
        
        if let sisteInnsendteAarsregnskap = company?.sisteInnsendteAarsregnskap {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-LatestSubmittedAnnualAccounts", comment: ""), description: String(sisteInnsendteAarsregnskap)))
        }
        
        if let konkurs = company?.konkurs {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-Bankrupt", comment: ""), description: decodeYesOrNo(konkurs)))
        }
        
        if let underAvvikling = company?.underAvvikling {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-UnderLiquidation", comment: ""), description: decodeYesOrNo(underAvvikling)))
        }
        
        if let underTvangsavviklingEllerTvangsopplosning = company?.underTvangsavviklingEllerTvangsopplosning {
            mainSection.cells.append(buildNonInteractiveCell(NSLocalizedString("Detail-ForcedResolution", comment: ""), description: decodeYesOrNo(underTvangsavviklingEllerTvangsopplosning)))
        }
        
        if let overordnetEnhet = company?.overordnetEnhet {
            let overordnetEnhetCell = buildCell(NSLocalizedString("Detail-Parent", comment: ""), description: String(overordnetEnhet))
            overordnetEnhetCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            mainSection.cells.append(overordnetEnhetCell)
        }
        
        sections.append(mainSection)
        
        if let institusjonellSektorkode = company?.institusjonellSektorkode {
            var sektorkodeSection = SectionCellData(header: NSLocalizedString("InstitutionalSectorCode-Section", comment: ""))
            
            if let kode = institusjonellSektorkode.kode {
                sektorkodeSection.cells.append(buildNonInteractiveCell(NSLocalizedString("InstitutionalSectorCode-Code", comment: ""), description: String(kode)))
            }
            
            if let beskrivelse = institusjonellSektorkode.beskrivelse {
                sektorkodeSection.cells.append(buildNonInteractiveCell(NSLocalizedString("InstitutionalSectorCode-Description", comment: ""), description: beskrivelse))
            }
            
            sections.append(sektorkodeSection)
        }
        
        if let naeringskode1 = company?.naeringskode1 {
            var naeringskode1Section = SectionCellData(header: NSLocalizedString("Naeringskode1-Section", comment: ""))
            naeringskode1Section.cells = buildNaeringskodeCells(naeringskode1)
            sections.append(naeringskode1Section)
        }
        
        if let naeringskode2 = company?.naeringskode2 {
            var naeringskode2Section = SectionCellData(header: NSLocalizedString("Naeringskode2-Section", comment: ""))
            naeringskode2Section.cells = buildNaeringskodeCells(naeringskode2)
            sections.append(naeringskode2Section)
        }
        
        if let naeringskode3 = company?.naeringskode3 {
            var naeringskode3Section = SectionCellData(header: NSLocalizedString("Naeringskode3-Section", comment: ""))
            naeringskode3Section.cells = buildNaeringskodeCells(naeringskode3)
            sections.append(naeringskode3Section)
        }
        
        if let postadresse = company?.postadresse {
            var postadresseSection = SectionCellData(header: NSLocalizedString("PostalAddress-Section", comment: ""))
            postadresseSection.cells = buildAdressCells(postadresse)
            sections.append(postadresseSection)
        }
        
        if let forretningsadresse = company?.forretningsadresse {
            var forretningsadresseSection = SectionCellData(header: NSLocalizedString("BusinessAddress-Section", comment: ""))
            forretningsadresseSection.cells = buildAdressCells(forretningsadresse)
            sections.append(forretningsadresseSection)
        }
        
        if let beliggenhetsadresse = company?.beliggenhetsadresse {
            var beliggenhetsadresseSection = SectionCellData(header: NSLocalizedString("LocationAddress-Section", comment: ""))
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
            if cellText == NSLocalizedString("Detail-Website", comment: "") {
                self.performSegue(withIdentifier: "showWebView", sender: self)
            } else if cellText == NSLocalizedString("Detail-Parent", comment: "") {
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
            let alert = UIAlertController(title: NSLocalizedString("ErrorLoadingDataTitle", comment: ""), message: NSLocalizedString("ErrorLoadingDataMessage", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func decodeYesOrNo(_ description: String) -> String {
        if description == "J" {
            return NSLocalizedString("Yes", comment: "")
        } else if description == "N" {
            return NSLocalizedString("No", comment: "")
        } else {
            return description
        }
    }
    
}
