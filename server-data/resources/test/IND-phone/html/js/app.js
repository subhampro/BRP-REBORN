IND = {}
IND.Phone = {}
IND.Screen = {}
IND.Phone.Functions = {}
IND.Phone.Animations = {}
IND.Phone.Notifications = {}
IND.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

efscreenlock = true

IND.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
}

IND.Phone.Data.MaxSlots = 16;

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;
var up = false

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob && IND.Phone.Data.PlayerData.job.onduty) {
                retval = true;
            }
        });
    }
    return retval;
}
IND.Phone.Functions.SetupApplications = function(data) {
    IND.Phone.Data.Applications = data.applications;

    var i;
    for (i = 1; i <= IND.Phone.Data.MaxSlots; i++) {
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+i+'"]');
        $(applicationSlot).html("");
        $(applicationSlot).css({
            "background-color":"transparent"
        });
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');
        $(applicationSlot).removeData('placement')
    }

    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, IND.Phone.Data.PlayerJob.name)

        if ((!app.job || app.job === IND.Phone.Data.PlayerJob.name) && !blockedapp) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            if (app.app == "meos") {
                icon = '<img src="./img/politie.png" class="ef-app-icon">';
            }
            if (app.app == "whatsapp") {
                icon = '<img src="./img/apps/whatsapp.png" class="ef-app-icon">';
            }
            if (app.app == "phone") {
                icon = '<img src="./img/apps/system_phone.png" class="ef-app-icon">';
            }
            if (app.app == "settings") {
                icon = '<img src="./img/apps/system_settings.png" class="ef-app-icon">';
            }
            if (app.app == "twitter") {
                icon = '<img src="./img/apps/twitter.png" class="ef-app-icon">';
            }
            if (app.app == "mail") {
                icon = '<img src="./img/apps/system_email.png" class="ef-app-icon">';
            }
            if (app.app == "camera") {
                icon = '<img src="./img/apps/system_camera.png" class="ef-app-icon">';
            }
            if (app.app == "gallery") {
                icon = '<img src="./img/apps/system_gallery.png" class="ef-app-icon">';
            }
            if (app.app == "calculator") {
                icon = '<img src="./img/apps/calculator.png" class="ef-app-icon">';
            }
            else if (app.app == "paytm"){
            icon = '<img src="./img/apps/paytm.png" class="ef-paytmapp-icon">';
            }
            if (app.app == "advert") {
                icon = '<img src="./img/apps/ads.png" class="ef-app-icon">';
            }
            if (app.app == "bank") {
                icon = '<img src="./img/apps/paypal.png" class="ef-app-icon">';
            }
            if (app.app == "garage") {
                icon = '<img src="./img/apps/carmudi.png" class="ef-app-icon">';
            }
            if (app.app == "bill"){
            icon = '<img src="./img/apps/invoices.png" class="ef-app-icon">';
            }
            if (app.app == "lawyers") {
                icon = '<img src="./img/apps/police-card.png" class="ef-app-icon">';
            }
            if (app.app == "racing") {
                icon = '<img src="./img/apps/racing.png" class="ef-app-icon">';
            }
            if (app.app == "crypto") {
                icon = '<img src="./img/apps/bitcoin.png" class="ef-app-icon">';
            }
            if (app.app == "ping") {
                icon = '<img src="./img/apps/maps.png" class="ef-app-icon">';
            }
            if (app.app == "houses") {
                icon = '<img src="./img/apps/home.png" class="ef-app-icon">';
            }
            if (app.app == "lsbn") {
                icon = '<img src="./img/apps/lsbn.png" class="ef-app-icon">';
            }
            if (app.app == "meos") {
                icon = '<img src="./img/apps/police1.png" class="ef-app-icon">';
            }
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
            $(applicationSlot).prop('title', app.tooltipText);
            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos)
            }
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}

// IND.Phone.Functions.SetupApplications = function(data) {
//     IND.Phone.Data.Applications = data.applications;

//     var i;
//     for (i = 1; i <= IND.Phone.Data.MaxSlots; i++) {
//         var applicationSlot = $(".phone-applications").find('[data-appslot="'+i+'"]');
//         $(applicationSlot).html("");
//         $(applicationSlot).css({
//             "background-color":"transparent"
//         });
//         $(applicationSlot).prop('title', "");
//         $(applicationSlot).removeData('app');
//         $(applicationSlot).removeData('placement')
//     }

//     $.each(data.applications, function(i, app){
//         var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
//         var blockedapp = IsAppJobBlocked(app.blockedjobs, IND.Phone.Data.PlayerJob.name)

//         if ((!app.job || app.job === IND.Phone.Data.PlayerJob.name) && !blockedapp) {
//             $(applicationSlot).css({"background-color":app.color});
//             var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
//             if (app.app == "meos") {
//                 icon = '<img src="./img/politie.png" class="police-icon">';
//             }
//             $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');
//             $(applicationSlot).prop('title', app.tooltipText);
//             $(applicationSlot).data('app', app.app);

//             if (app.tooltipPos !== undefined) {
//                 $(applicationSlot).data('placement', app.tooltipPos)
//             }
//         }
//     });

//     $('[data-toggle="tooltip"]').tooltip();
// }

IND.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');

        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

IND.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (IND.Phone.Data.currentApplication == null) {
                IND.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                IND.Phone.Functions.ToggleApp(PressedApplication, "block");

                if (IND.Phone.Functions.IsAppHeaderAllowed(PressedApplication)) {
                    IND.Phone.Functions.HeaderTextColor("black", 300);
                }

                IND.Phone.Data.currentApplication = PressedApplication;

                if (PressedApplication == "settings") {
                    $("#myPhoneNumber").text(IND.Phone.Data.PlayerData.charinfo.phone);
                    $("#mySerialNumber").text("IND-" + IND.Phone.Data.PlayerData.metadata["phonedata"].SerialNumber);
                } else if (PressedApplication == "twitter") {
                    $.post('https://ef-phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        IND.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('https://ef-phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        IND.Phone.Notifications.LoadHashtags(Hashtags)
                    })
                    if (IND.Phone.Data.IsOpen) {
                        $.post('https://ef-phone/GetTweets', JSON.stringify({}), function(Tweets){
                            IND.Phone.Notifications.LoadTweets(Tweets);
                        });
                    }
                } else if (PressedApplication == "bank") {
                    IND.Phone.Functions.DoBankOpen();
                    $.post('https://ef-phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        IND.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('https://ef-phone/GetInvoices', JSON.stringify({}), function(invoices){
                        IND.Phone.Functions.LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('https://ef-phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        IND.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('https://ef-phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        IND.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('https://ef-phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        IND.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('https://ef-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('https://ef-phone/GetMails', JSON.stringify({}), function(mails){
                        IND.Phone.Functions.SetupMails(mails);
                    });
                    $.post('https://ef-phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('https://ef-phone/LoadAdverts', JSON.stringify({}), function(Adverts){
                        IND.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('https://ef-phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('https://ef-phone/GetCryptoData', JSON.stringify({
                        crypto: "qbit",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('https://ef-phone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    });
                } else if (PressedApplication == "racing") {
                    $.post('https://ef-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('https://ef-phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                    $.post('https://ef-phone/GetPlayerKeys', JSON.stringify({}), function(Keys){
                        $(".house-app-mykeys-container").html("");
                        if (Keys.length > 0) {
                            $.each(Keys, function(i, key){
                                var elem = '<div class="mykeys-key" id="keyid-'+i+'"><span class="mykeys-key-label">' + key.HouseData.adress + '</span> <span class="mykeys-key-sub">Click to set GPS</span> </div>';
                                $(".house-app-mykeys-container").append(elem);
                                $("#keyid-"+i).data('KeyData', key);
                            });
                        }
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                } else if (PressedApplication == "lawyers") {
                    $.post('https://ef-phone/GetCurrentLawyers', JSON.stringify({}), function(data){
                        SetupLawyers(data);
                    });
                } else if (PressedApplication == "store") {
                    $.post('https://ef-phone/SetupStoreApps', JSON.stringify({}), function(data){
                        SetupAppstore(data);
                    });
                } else if (PressedApplication == "trucker") {
                    $.post('https://ef-phone/GetTruckerData', JSON.stringify({}), function(data){
                        SetupTruckerInfo(data);
                    });
                }
                else if (PressedApplication == "jobcenter") {
                    LoadJobCenter();
                }

                else if (PressedApplication == "gallery") {
                    $.post('https://ef-phone/GetGalleryData', JSON.stringify({}), function(data){
                        setUpGalleryData(data);
                    });
                }
                else if (PressedApplication == "camera") {
                    $.post('https://ef-phone/TakePhoto', JSON.stringify({}),function(url){
                        setUpCameraApp(url)
                    })
                    IND.Phone.Functions.Close();
                }
                else if (PressedApplication == "bill") {
                    LoadbillJob();
                }
                else if (PressedApplication == "lsbn") {
                    LoadLSBNEvent();
                }

                
            }
        }
    } else {
        if (PressedApplication != null){
            IND.Phone.Notifications.Add("fas fa-exclamation-circle", "System", IND.Phone.Data.Applications[PressedApplication].tooltipText+" is not available!")
        }
    }
});

$(document).on('click', '.mykeys-key', function(e){
    e.preventDefault();

    var KeyData = $(this).data('KeyData');

    $.post('https://ef-phone/SetHouseLocation', JSON.stringify({
        HouseData: KeyData
    }))
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (IND.Phone.Data.currentApplication === null) {
        IND.Phone.Functions.Close();
    } else {
        IND.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        IND.Phone.Animations.TopSlideUp('.'+IND.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            IND.Phone.Functions.ToggleApp(IND.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
        }, 400)
        IND.Phone.Functions.HeaderTextColor("white", 300);

        if (IND.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (IND.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});

                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');

                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');

                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (IND.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"});
            }, 400)
        }

        IND.Phone.Data.currentApplication = null;
    }
});

IND.Phone.Functions.Open = function(data) {
    IND.Phone.Animations.BottomSlideUp('.container', 300, 0);
    IND.Phone.Notifications.LoadTweets(data.Tweets);
    IND.Phone.Data.IsOpen = true;
}

IND.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

IND.Phone.Functions.Close = function() {

    if (IND.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            IND.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            IND.Phone.Animations.TopSlideUp('.'+IND.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            IND.Phone.Functions.HeaderTextColor("white", 300);

            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: 0+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            IND.Phone.Data.currentApplication = null;
        }, 500)
    } else if (IND.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"});
    }

    $('.publicphonebase').css('display', 'none')
    $('.lock-screen').css('display', 'block')
    $('.phone-footer').css('display', 'none')   
    IND.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('https://ef-phone/Close');
    IND.Phone.Data.IsOpen = false;
}

IND.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

IND.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

IND.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

IND.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

IND.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

IND.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    $.post('https://ef-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 1500;
            }
            if (IND.Phone.Notifications.Timeout == undefined || IND.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!IND.Phone.Data.IsOpen) {
                    IND.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                IND.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                if (icon !== "politie") {
                    $(".notification-icon").html('<i class="'+icon+'"></i>');
                } else {
                    $(".notification-icon").html('<img src="./img/politie.png" class="police-icon-notify">');
                }
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (IND.Phone.Notifications.Timeout !== undefined || IND.Phone.Notifications.Timeout !== null) {
                    clearTimeout(IND.Phone.Notifications.Timeout);
                }
                IND.Phone.Notifications.Timeout = setTimeout(function(){
                    IND.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!IND.Phone.Data.IsOpen) {
                        IND.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    IND.Phone.Notifications.Timeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                if (!IND.Phone.Data.IsOpen) {
                    IND.Phone.Animations.BottomSlideUp('.container', 300, -52);
                }
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (IND.Phone.Notifications.Timeout !== undefined || IND.Phone.Notifications.Timeout !== null) {
                    clearTimeout(IND.Phone.Notifications.Timeout);
                }
                IND.Phone.Notifications.Timeout = setTimeout(function(){
                    IND.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    if (!IND.Phone.Data.IsOpen) {
                        IND.Phone.Animations.BottomSlideUp('.container', 300, -100);
                    }
                    IND.Phone.Notifications.Timeout = null;
                }, timeout);
            }
        }
    });
}

IND.Phone.Functions.LoadPhoneData = function(data) {
    IND.Phone.Data.PlayerData = data.PlayerData;
    IND.Phone.Data.PlayerJob = data.PlayerJob;
    IND.Phone.Data.MetaData = data.PhoneData.MetaData;
    IND.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    IND.Phone.Functions.LoadContacts(data.PhoneData.Contacts);
    IND.Phone.Functions.SetupApplications(data);

    $("#player-id").html("<span>" + "ID: " + data.PlayerId + "</span>")
}


IND.Phone.Functions.UpdateTime = function(data) {
    var NewDate = new Date();
    var NewHour = NewDate.getHours();
    var NewMinute = NewDate.getMinutes();
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    var MessageTime = Hourssssss + ":" + Minutessss

    $("#phone-time").html("<span>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
    $("#ef-phone-time").html("<span>" + data.InGameTime.hour + ":" + data.InGameTime.minute + "</span>");
}

var NotificationTimeout = null;

IND.Screen.Notification = function(title, content, icon, timeout, color) {
    $.post('https://ef-phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (color != null && color != undefined) {
                $(".screen-notifications-container").css({"background-color":color});
            }
            $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
            $(".screen-notification-title").text(title);
            $(".screen-notification-content").text(content);
            $(".screen-notifications-container").css({'display':'block'}).animate({
                right: 5+"vh",
            }, 200);

            if (NotificationTimeout != null) {
                clearTimeout(NotificationTimeout);
            }

            NotificationTimeout = setTimeout(function(){
                $(".screen-notifications-container").animate({
                    right: -35+"vh",
                }, 200, function(){
                    $(".screen-notifications-container").css({'display':'none'});
                });
                NotificationTimeout = null;
            }, timeout);
        }
    });
}

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27: // ESCAPE
        if (up){
            $('#popup').fadeOut('slow');
            $('.popupclass').fadeOut('slow');
            $('.popupclass').html("");
            up = false
        } else {
            IND.Phone.Functions.Close();
            break;
        }
    }
});

IND.Screen.popUp = function(source){
    if(!up){
        $('#popup').fadeIn('slow');
        $('.popupclass').fadeIn('slow');
        $('<img  src='+source+' style = "width:100%; height: 100%;">').appendTo('.popupclass')
        up = true
    }
}

IND.Screen.popDown = function(){
    if(up){
        $('#popup').fadeOut('slow');
        $('.popupclass').fadeOut('slow');
        $('.popupclass').html("");
        up = false
    }
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                IND.Phone.Functions.Open(event.data);
                IND.Phone.Functions.SetupAppWarnings(event.data.AppData);
                IND.Phone.Functions.SetupCurrentCall(event.data.CallData);
                IND.Phone.Data.IsOpen = true;
                IND.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            case "LoadPhoneData":
                IND.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                IND.Phone.Functions.UpdateTime(event.data);
                break;
            case "Notification":
                IND.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                IND.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                IND.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
            case "UpdateMentionedTweets":
                IND.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&#36; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (IND.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                        IND.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                        IND.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                IND.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                IND.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('https://ef-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('https://ef-phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                IND.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                IND.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);
                if (!IND.Phone.Data.IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("In conversation ("+timeString+")");
                    $(".call-notifications-content").html("Calling with "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }
                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In conversation ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                IND.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    IND.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                IND.Phone.Functions.HeaderTextColor("white", 300);

                IND.Phone.Data.CallActive = false;
                IND.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                IND.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                IND.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (IND.Phone.Data.currentApplication == "advert") {
                    IND.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "UpdateTweets":
                if (IND.Phone.Data.currentApplication == "twitter") {
                    IND.Phone.Notifications.LoadTweets(event.data.Tweets);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateApplications":
                IND.Phone.Data.PlayerJob = event.data.JobData;
                IND.Phone.Functions.SetupApplications(event.data);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('https://ef-phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "RefreshAlerts":
                IND.Phone.Functions.SetupAppWarnings(event.data.AppData);
                break;
        }
    })
});

$(document).on("click", ".triggerHelp", function(){
    $.ajax({
        url: 'https://ef-phone/openHelp',
        method: 'POST',
    })
})


$(document).on("click", ".ef-finger", function(e){
    e.preventDefault();
    $(".lock-screen").css({"display":"none"});
    $(".phone-footer").css({"display":"block"});
    
})