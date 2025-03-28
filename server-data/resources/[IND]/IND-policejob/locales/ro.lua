--[[
Romanian base language translation for IND-policejob
Translation done by wanderrer (Martin Riggs#0807 on Discord)
]]--
local Translations = {
    error = {
        license_already = 'Cetateanul are deja permis',
        error_license = 'Cetateanul nu are acel permis',
        no_camera = 'Aceasta camera video nu exista',
        blood_not_cleared = 'Urmele de sange NU au fost inlaturate/colectate.',
        bullet_casing_not_removed = 'Cartusele NU au fost inlaturate/colectate.',
        none_nearby = 'Nu este nimeni langa tine!',
        canceled = 'Anulat..',
        time_higher = 'Perioada de timp trebuie sa fie mai mare de 0',
        amount_higher = 'Suma de plata trebuie sa fie mai mare de 0',
        vehicle_cuff = 'Nu poti pune catusele unei persoane in vehicul',
        no_cuff = 'Nu ai catuse disponibile la tine',
        no_impound = 'Nu exista niciun vehicul confiscat',
        no_spikestripe = 'Nu mai poti pune tepuse pentru cauciucuri',
        error_license_type = 'Tip de permis invalid',
        rank_license = 'Nu ai grad suficient de mare pentru a acorda un permis',
        revoked_license = 'Permisul ti-a fost suspendat',
        rank_revoke = 'Nu ai grad suficient de mare pentru a revoca/suspenda un permis',
        on_duty_police_only = 'Disponibil doar ofiterilor activi (on-duty)',
        vehicle_not_flag = 'Vehiculul nu are niciun flag activ',
        not_towdriver = 'Nu este agent de remorcari',
        not_lawyer = 'Cetateanul nu este avocat, atentie!',
        no_anklet = 'Cetateanul nu are bratara de urmarire la picior.',
        have_evidence_bag = 'Iti trebuie o punga pentru dovezi goala, se pare ca nu ai asa ceva la tine.',
        no_driver_license = 'Lipsa permis conducere',
        not_cuffed_dead = 'Cetateanul nu are catusele puse si nici nu este mort/ranit.',
        fine_yourself = '???',
        not_online = "???"
    },
    success = {
        uncuffed = 'Ti-au fost scoase catusele',
        granted_license = 'Ai primit un permis valid',
        grant_license = 'Ai eliberat o adeverinta pentru permis',
        revoke_license = 'Ai suspendat un permis',
        tow_paid = 'Ai fost platit $500',
        blood_clear = 'Urmele de sange au fost colectate',
        bullet_casing_removed = 'Cartusele au fost adunate...',
        anklet_taken_off = 'Trackerul ti-a fost scos.',
        took_anklet_from = 'Trackerul pentru %{firstname} %{lastname} a fost inlaturat/dezactivat.',
        put_anklet = 'Ai activat un tracker de urmarire.',
        put_anklet_on = 'Ai montat un tracker pentru %{firstname} %{lastname}',
        vehicle_flagged = 'Vehiculul cu numarul %{plate} are flag pentru %{reason}',
        impound_vehicle_removed = 'Vehiculul a fost scos din impound!',
        impounded = 'Vehicul confiscat (impounded)',
 },
    info = {
        mr = 'D-nul.',
        mrs = 'D-na.',
        impound_price = 'Pretul platit de cetateni pentru a scoate masinile sechestrare (poate sa fie 0)',
        plate_number = 'Numarul de inmatriculare',
        flag_reason = 'Motivul flagului activ',
        camera_id = 'ID-ul camerei video',
        callsign_name = 'Callsignul tau (numar matricol)',
        poobject_object = 'Tipul obiectului de spawnat sau de sters',
        player_id = 'ID-ul cetateanului',
        citizen_id = 'CNP-ul cetateanului',
        dna_sample = 'Proba ADN',
        jail_time = 'Timpul aferent pedepsei de incarcerare',
        jail_time_no = 'Timpul de incarcerare trebuie sa fie mai mare de 0',
        license_type = 'Tipul permisului (conducere/portarma)',
        ankle_location = 'Locatia trackerului',
        cuff = 'Ai fost incatusat!',
        cuffed_walk = 'Ai fost incatusat, dar te poti misca',
        vehicle_flagged = 'Vehiculul %{vehicle} are flag activ pentru: %{reason}',
        unflag_vehicle = 'Vehiculul %{vehicle} nu are flag activ',
        tow_driver_paid = 'Ai platit agentul de remorcari',
        paid_lawyer = 'Ai platit avocatul',
        vehicle_taken_depot = 'Vehiculul a fost sechestrat, pentru suma de $%{price}',
        vehicle_seized = 'Vehicul confiscat/sechestrat',
        stolen_money = 'Ai furat suma de $%{stolen}',
        cash_robbed = 'Ti-a fost furata suma de $%{money}',
        driving_license_confiscated = 'Permisul de conducere ti-a fost confiscat',
        cash_confiscated = 'Ti-au fost confiscati toti banii de pe tine',
        being_searched = 'Esti perchezitionat(a)!',
        cash_found = 'S-a gasit suma de $%{cash} pe cetatean',
        sent_jail_for = 'Ai trimis cetateanul la inchisoare pentru %{time} luni',
        fine_received = 'Ai primit o amenda in valoare de $%{fine}',
        blip_text = 'Alerta M.A.I - %{value}',
        jail_time_input = 'Perioada de incarcerare',
        submit = 'Strimite',
        time_months = 'Timp in luni de zile',
        bill = 'Facturi',
        amount = 'Suma',
        police_plate = 'LSPD', --Should only be 4 characters long
        vehicle_info = 'Motor: %{value} % | Combustibil: %{value2} %',
        evidence_stash = 'Fisiet dovezi | %{value}',
        slot = 'Slot nr. (1,2,3)',
        current_evidence = '%{value} | Sertar %{value2}',
        on_duty = '[E] - Intra in tura',
        off_duty = '[E] - Iesi din tura',
        onoff_duty = '~g~Intra~s~/~r~Iesi~s~ din tura',
        stash = 'Fiset %{value}',
        delete_spike = '[~r~E~s~] Sterge tepusele',
        close_camera = 'Inchide camera',
        bullet_casing = '[~g~G~s~] Cartusele %{value}',
        casing = 'Cartuse',
        blood = 'Sange',
        blood_text = '[~g~G~s~] Sange %{value}',
        fingerprint_text = '[G] Amprente',
        fingerprint = 'Amprente',
        store_heli = '[E] Parcheaza elicopterul',
        take_heli = '[E] Foloseste elicopterul',
        impound_veh = '[E] Confisca vehicul',
        store_veh = '[E] - Parcheaza vehicul',
        armory = 'Armurier',
        enter_armory = '[E] Armurier',
        finger_scan = 'Scaneaza amprentele',
        scan_fingerprint = '[E] Scaneaza amprentele',
        trash = 'Gunoi',
        trash_enter = '[E] Cos de gunoi',
        stash_enter = '[E] Vestiar',
        target_location = 'Locatia pentru %{firstname} %{lastname} este marcata pe GPS.',
        anklet_location = 'Pozitionarea trackerului',
        new_call = 'Apel nou',
        officer_down = 'Colegul nostru %{lastname} | %{callsign} a fost ranit!',
        fine_issued = '???',
        received_fine = '???'
    },
    evidence = {
        red_hands = 'Maini zgariate',
        wide_pupils = 'Pupile dilatate',
        red_eyes = 'Ochi rosii',
        weed_smell = 'Miroase a iarba',
        gunpowder = 'Praf de pusca pe haine',
        chemicals = 'miros de chimicale puternic',
        heavy_breathing = 'Respira greu',
        sweat = 'Transpira mult',
        handbleed = 'Sange pe maini',
        confused = 'Confuz',
        alcohol = 'Miroase a alcool',
        heavy_alcohol = 'Miroase tare a alcool',
        agitated = 'Agitat - posibil consum de metamfetamina',
        serial_not_visible = 'Codul de serie nu este vizibil...',
    },
    menu = {
        garage_title = 'Vehicule MAI',
        close = '⬅ Inchide meniul',
        impound = 'Vehicule confiscate',
        pol_impound = 'Police Impound',
        pol_garage = 'Garaj MAI',
        pol_armory = 'Armurier',
    },
    email = {
        sender = 'Agentia Nationala de Administrare Fiscala',
        subject = 'Colectare datorii',
        message = 'Stimate %{value}. %{value2}, <br /><br />Agentia Nationala de Administrare Fiscala (ANAF) aa aduce la cunostinta faptul ca din conturile dumneavoastra a fost retrasa o suma de bani, reprezentand amenzi primite pe teritoriul statul San Andreas.<br />Suma retrasa este de <strong>$%{value3}</strong>.<br /><br />Cu stima,<br />Alexandru Vasilescu',
    },
    commands = {
        place_spike = 'Plaseaza tapuse pe strada (Doar pentru M.A.I)',
        license_grant = 'Ofera un permis unei persoane.',
        license_revoke = 'Suspenda permisul unei persoane',
        place_object = 'Plaseaza/Sterge un obiect (Doar pentru M.A.I)',
        cuff_player = 'Incatuseaza un cetatean (Doar pentru M.A.I)',
        escort = 'Escorteaza un cetatean',
        callsign = 'Iti setezi numarul matricol',
        clear_casign = 'Colectezi cartusele din zona (Doar pentru M.A.I)',
        jail_player = 'Trimiti un cetatean la inchisoare (Doar pentru M.A.I)',
        unjail_player = 'Scoti de la inchisoare un cetatean (Doar pentru M.A.I)',
        clearblood = 'Colectezi probele de sange din zona (Doar pentru M.A.I)',
        seizecash = 'Confisti banii unui cetatean (Doar pentru M.A.I)',
        softcuff = 'Incatusare usoara (Doar pentru M.A.I)',
        camera = 'Urmareste o camera de securitate (Doar pentru M.A.I)',
        flagplate = 'Pune flag unui vehicul (Doar pentru M.A.I)',
        unflagplate = 'Scoate flagul unui vehicul (Doar pentru M.A.I)',
        plateinfo = 'Verifica un numar de inmatriculare (Doar pentru M.A.I)',
        depot = 'Confisca un vehicul cu plata (Doar pentru M.A.I)',
        impound = 'Confisca un behicul fara plata (Doar pentru M.A.I)',
        paytow = 'Plateste un agent de remorcari (Doar pentru M.A.I)',
        paylawyer = 'Plateste un avocat (M.A.I sau M.J)',
        anklet = 'Monteaza un device de tracking (Doar pentru M.A.I)',
        ankletlocation = 'Obtine locatia unui device de tracking',
        removeanklet = 'Dezactivezi si scoti un device de tracking (Doar pentru M.A.I)',
        drivinglicense = 'Suspendarea si confiscarea permisului de conducere (Doar pentru M.A.I)',
        takedna = 'Iei o proba de ADN de la un cetatean (necesita punga goala de dovezi) (Doar pentru M.A.I)',
        police_report = 'Raport al M.A.I',
        message_sent = 'Mesaj de trimis',
        civilian_call = 'Apel de la cetateni',
        emergency_call = 'Apel la 911',
        fine = '???'
    },
    progressbar = {
        blood_clear = 'Strangi urmele de sange...',
        bullet_casing = 'Strangi cartusele..',
        robbing = 'Jefuiesti un cetatean...',
        place_object = 'Plasezi un obiect..',
        remove_object = 'Strangi un obiect..',
        impound = 'Comfisti un vehicul..',
    },
}

if GetConvar('IND_locale', 'en') == 'ro' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
