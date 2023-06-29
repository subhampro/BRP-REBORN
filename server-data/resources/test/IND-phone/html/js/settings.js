IND.Phone.Settings = {};
IND.Phone.Settings.Background = "ef-wallpaper";
IND.Phone.Settings.OpenedTab = null;
IND.Phone.Settings.Backgrounds = {
    'ef-wallpaper': {
        label: "Bharat Reborn"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        IND.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        IND.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        IND.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        IND.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        IND.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", IND.Phone.Data.AnonymousCall);

        if (!IND.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = IND.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        IND.Phone.Notifications.Add("fas fa-paint-brush", "Settings", IND.Phone.Settings.Backgrounds[IND.Phone.Settings.Background].label+" is set!")
        IND.Phone.Animations.TopSlideUp(".settings-"+IND.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+IND.Phone.Settings.Background+".png')"})
    } else {
        IND.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal background set!")
        IND.Phone.Animations.TopSlideUp(".settings-"+IND.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+IND.Phone.Settings.Background+"')"});
    }

    $.post('https://ef-phone/SetBackground', JSON.stringify({
        background: IND.Phone.Settings.Background,
    }))
});

IND.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        IND.Phone.Settings.Background = MetaData.background;
    } else {
        IND.Phone.Settings.Background = "ef-wallpaper";
    }

    var hasCustomBackground = IND.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+IND.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+IND.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/avatar.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    IND.Phone.Animations.TopSlideUp(".settings-"+IND.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

IND.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(IND.Phone.Settings.Backgrounds, function(i, background){
        if (IND.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            IND.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            IND.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    IND.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    IND.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    IND.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = IND.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        IND.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Standard avatar set!")
        IND.Phone.Animations.TopSlideUp(".settings-"+IND.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/avatar.png">');
    } else {
        IND.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal avatar set!")
        IND.Phone.Animations.TopSlideUp(".settings-"+IND.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('https://ef-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    IND.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    IND.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            IND.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            IND.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    IND.Phone.Animations.TopSlideUp(".settings-"+IND.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    IND.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});
