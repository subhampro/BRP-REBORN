local Translations = {
    error = {
        license_already = 'Hráč už má licenciu',
        error_license = 'Hráč túto licenciu nemá',
        no_camera = 'Kamera neexistuje',
        blood_not_cleared = 'Krv NIE JE vyčistená',
        bullet_casing_not_removed = 'Puzdrá nábojov NIE sú odstránené',
        none_nearby = 'Nikto nablízku!',
        canceled = 'Zrušené..',
        time_higher = 'Čas musí byť väčší ako 0',
        amount_higher = 'Suma musí byť vyššia ako 0',
        vehicle_cuff = 'Nemôžete pripútať niekoho, kto je vo vozidle',
        no_cuff = 'Nemáš pri sebe putá',
        no_impound = 'Nenašli sa žiadne odtiahnuté vozidlá',
        no_spikestripe = 'Nie je možné umiestniť ďalšie pásiky s hrotmi',
        error_license_type = 'Neplatný typ licencie',
        rank_license = 'Nemáte dostatočne vysokú hodnosť na udelenie licencie',
        revoked_license = 'Bola vám odobratá licencia',
        rank_revoke = 'Nemáte dostatočne vysokú hodnosť na odobratie licencie',
        on_duty_police_only = 'Len pre políciu v službe',
        vehicle_not_flag = 'Vozidlo nie je označené',
        not_towdriver = 'Nie je vodič odťahovky',
        not_lawyer = 'Osoba nie je právnik',
        no_anklet = 'Táto osoba nemá členkový sledovač.',
        have_evidence_bag = 'Musíte mať so sebou prázdnu tašku s dôkazmi',
        no_driver_license = 'Žiaden vodičský preukaz',
        not_cuffed_dead = 'Civilista nie je spútaný a ani mŕtvy',
        fine_yourself = '???',
        not_online = "???"
    },
    success = {
        uncuffed = 'Boli ste zbavení pút',
        granted_license = 'Bola vám udelená licencia',
        grant_license = 'Udelili ste licenciu',
        revoke_license = 'Odobrali ste licenciu',
        tow_paid = 'Dostali ste zaplatené $500',
        blood_clear = 'Krv vyčistená',
        bullet_casing_removed = 'Odstránená nábojnica...',
        anklet_taken_off = 'Váš členkový sledovač je odstránený.',
        took_anklet_from = 'Dal si dole sledovač osobe %{firstname} %{lastname}',
        put_anklet = 'Nasadil si členkový sledovač.',
        put_anklet_on = 'Nasadil si sledovač osobe %{firstname} %{lastname}',
        vehicle_flagged = 'Vozidlo %{plate} bol označený pre %{reason}',
        impound_vehicle_removed = 'Vozidlo vytiahnuté z odťahovky!',
    },
    info = {
        mr = 'Pán',
        mrs = 'Pani',
        impound_price = 'Cena, ktorú hráč zaplatí, aby dostal vozidlo zo zabavenia (môže byť 0)',
        plate_number = 'Evidenčné číslo',
        flag_reason = 'Dôvod označenia vozidla',
        camera_id = 'ID kamery',
        callsign_name = 'Názov vašej volacej značky',
        poobject_object = 'Typ objektu na vytvorenie alebo na odstránenie',
        player_id = 'ID Hráča',
        citizen_id = 'ID Osoby',
        dna_sample = 'Vzorka DNA',
        jail_time = 'Čas, kedy musia byť vo väzení',
        jail_time_no = 'Čas väzenia musí byť vyšší ako 0',
        license_type = 'Typ licencie (vodičký/zborjný)',
        ankle_location = 'Lokalizácia sledovača',
        cuff = 'Si spútaný!',
        cuffed_walk = 'Si spútaný, ale môžeš chodiť',
        vehicle_flagged = 'Vozidlo %{vehicle} je označené pre: %{reason}',
        unflag_vehicle = 'Vozidlo %{vehicle} už nie je označené',
        tow_driver_paid = 'Zaplatil si vodičovi odťahovky',
        paid_lawyer = 'Zaplatil si právnika',
        vehicle_taken_depot = 'Vozidlo odvezené do depa za $%{price}',
        vehicle_seized = 'Vozidlo bolo zaistené',
        stolen_money = 'Ukradol si $%{stolen}',
        cash_robbed = 'Boli ste okradnutý o $%{money}',
        driving_license_confiscated = 'Váš vodičský preukaz bol zadržaný',
        cash_confiscated = 'Vaša hotovosť bola zabavená',
        being_searched = 'Ste prehľadavný',
        cash_found = 'Nájdených $%{cash} u osoby',
        sent_jail_for = 'Poslal si osobu do väzenia na %{time} mesiac/e',
        fine_received = 'Dostali ste pokutu za $%{fine}',
        blip_text = 'Policia Upozornenie - %{text}',
        jail_time_input = 'Čas väzenia',
        submit = 'Potvrdiť',
        time_months = 'Čas v mesiacoch',
        bill = 'účet',
        amount = 'Čiastka',
        police_plate = 'PD', --Should only be 4 characters long
        vehicle_info = 'Motor: %{value} % | Palivo: %{value2} %',
        evidence_stash = 'Úložisko pre Dôkazy | %{value}',
        slot = 'Priestor č. (1,2,3)',
        current_evidence = '%{value} | Zásuvka %{value2}',
        on_duty = '[~g~E~s~] - Ísť do služby',
        off_duty = '[~r~E~s~] - Ísť mimo službu',
        onoff_duty = '~g~On~s~/~r~Off~s~ Duty',
        stash = 'Úložisko %{value}',
        delete_spike = '[~r~E~s~] Odstrániť Spajky',
        close_camera = 'Zatvoriť kameru',
        bullet_casing = '[~g~G~s~] Nábojnica %{value}',
        casing = 'Nábojnica',
        blood = 'Krv',
        blood_text = '[~g~G~s~] Krv %{value}',
        fingerprint_text = '[~g~G~s~] Odtlačok Prsta',
        fingerprint = 'Odtlačok Prsta',
        store_heli = '[~g~E~s~] Uložiť helikoptéru',
        take_heli = '[~g~E~s~] Vybrať helikoptéru',
        impound_veh = '[~g~E~s~] - Vybrať vozidlo',
        store_veh = '[~g~E~s~] - Vložiť vozidlo',
        armory = 'Zbrojnica',
        enter_armory = '[~g~E~s~] Zbrojnica',
        finger_scan = 'Skenovanie odtlačku prsta',
        scan_fingerprint = '[~g~E~s~] Skenovanie odtlačku prsta',
        trash = 'Smetie',
        trash_enter = '[~g~E~s~] Odpadkový kôš',
        stash_enter = '[~g~E~s~] Otvoriť úložisko',
        target_location = 'Lokácia osoby ${firstname} ${lastname} je vyznačená na mape',
        anklet_location = 'Lokácia sledovača',
        new_call = 'Nový hovor',
        fine_issued = '???',
        received_fine = '???'
    },
    evidence = {
        red_hands = 'Červené ruky',
        wide_pupils = 'Rozšírené zreničky',
        red_eyes = 'Červené oči',
        weed_smell = 'Vonia za trávou',
        gunpowder = 'Pušný prach na oblečení',
        chemicals = 'Vonia za chemikáliou',
        heavy_breathing = 'Ťažko dýcha',
        sweat = 'Veľmi sa potí',
        handbleed = 'Krv na rukách',
        confused = 'Zmätený',
        alcohol = 'Vonia za alkoholom',
        heavy_alcohol = 'Vonia veľmi za alkoholom',
        agitated = 'Rozrušený - Známky užívania pervitínu',
        serial_not_visible = 'Sériové číslo nie je viditeľné...',
    },
    menu = {
        garage_title = 'Policajné vozidlá',
        close = '⬅ Zatvoriť menu',
        impound = 'Odtiahnuté vozidlá',
        pol_impound = 'Policajná odťahovka',
        pol_garage = 'Policajná garáž',
        pol_armory = 'Policajná zbrojnica',
    },
    email = {
        sender = 'Ústredná Súdna Inkasná Agentúra',
        subject = 'Vymáhanie pohľadávok',
        message = 'Vážený/á %{value}. %{value2}, <br /><br />Centrálna súdna inkasná agentúra (CJCA) vám zaúčtovala pokuty, ktoré ste dostali od polície.<br />Bolo vám odobraných <strong>$%{value3}</strong> z vašého účtu.<br /><br />S priateľským pozdravom,<br />Mr. I.K. Graai',
    },
    commands = {
        place_spike = 'Položiť Spajky (Len Polícia)',
        license_grant = 'Udeliť niekomu licenciu',
        license_revoke = 'Odobrať niekomu licenciu',
        place_object = 'Umiestniť/Vymazať objekt (Len Polícia)',
        cuff_player = 'Spútať osobu (Len Polícia)',
        escort = 'Eskortovať osobu',
        callsign = 'Nastaviť si volaciu značku',
        clear_casign = 'Vyčistiť oblasť puzdier (Len Polícia)',
        jail_player = 'Uväzniť osobu (Len Polícia)',
        unjail_player = 'Zrušte väzenie osoby (Len Polícia)',
        clearblood = 'Vyčistiž oblasť krvi (Len Polícia)',
        seizecash = 'Zabaviť hotovosť (Len Polícia)',
        softcuff = 'Jemné Cuff (Len Polícia)',
        camera = 'Pozrieť si bezpečnostnú kameru (Len Polícia)',
        flagplate = 'Označiť ŠPZ (Len Polícia)',
        unflagplate = 'Odstrániť označenie ŠPZ (Len Polícia)',
        plateinfo = 'Vyhľadať ŠPZ (Len Polícia)',
        depot = 'Zabavenie s cenou (Len Polícia)',
        impound = 'Zabaviť vozidlo (Len Polícia)',
        paytow = 'Zaplatiť vodiča odťahovej služby (Len Polícia)',
        paylawyer = 'Zaplatiť právnika (Len Polícia a Súd)',
        anklet = 'Nasadiť sledovací náramok (Len Polícia)',
        ankletlocation = 'Získajte polohu sledovača osoby',
        removeanklet = 'Odstráňte sledovací náramok (Len Polícia)',
        drivinglicense = 'Seize Drivers License (Len Polícia)',
        takedna = 'Odoberte vzorku DNA od osoby (potrebné prázdne vrecko na dôkazy) (Len Polícia)',
        police_report = 'Policajná správa',
        message_sent = 'Správa na odoslanie',
        civilian_call = 'Hovor od civilistu',
        emergency_call = 'Nový 911 hovor',
        fine = '???'
    },
    progressbar = {
        blood_clear = 'Čistíš krv...',
        bullet_casing = 'Odstráňuješ púzdra od nábojníc..',
        robbing = 'Okrádaš...',
        place_object = 'Pokládaš objekt..',
        remove_object = 'Odstraňuješ objekt..',
    },
}

if GetConvar('IND_locale', 'en') == 'sk' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
