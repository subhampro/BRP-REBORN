OSClothing = {}

var selectedTab = ".characterTab"
var lastCategory = "character"
var selectedCam = null;
var hasTracker = false;
var canChange = true;

var clothingCategorys = [];

$(document).on('click', '.clothing-menu-header-btn', function(e){
    var category = $(this).data('category');

    $(selectedTab).removeClass("selected");
    $(this).addClass("selected");
    $(".clothing-menu-"+lastCategory+"-container").css({"display": "none"});

    lastCategory = category;
    selectedTab = this;

    $(".clothing-menu-"+category+"-container").css({"display": "block"});
})

OSClothing.ResetItemTexture = function(obj, category) {
    var itemTexture = $(obj).parent().parent().find('[data-type="texture"]');
    var defaultTextureValue = clothingCategorys[category].defaultTexture;
    $(itemTexture).val(defaultTextureValue);

    $.post('http://IND-clothing/updateSkin', JSON.stringify({
        clothingType: category,
        articleNumber: defaultTextureValue,
        type: "texture",
    }));
}

$(document).on('click', '.clothing-menu-option-item-right', function(e){
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) + 1;

    if (canChange) {
        if (hasTracker && clothingCategory == "accessory") {
            $.post('http://IND-clothing/TrackerError');
            return
        } else {
            if (clothingCategory == "model") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
                    $("#current-model").html("<p>"+model+"</p>")
                });
                canChange = true;
                OSClothing.ResetValues()
            } else if (clothingCategory == "hair") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "face") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "arms") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "shoes") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "bag") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "decals") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "t-shirt") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "torso2") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "pants") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "vest") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "accessory") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "ageing") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "beard") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "ear") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "watch") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "bracelet") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "lipstick") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "eyebrows") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "blush") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "makeup") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "mask") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "glass") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else if (clothingCategory == "hat") {
                $(inputElem).val(newValue);
                $.post('http://IND-clothing/updateSkin', JSON.stringify({
                    clothingType: clothingCategory,
                    articleNumber: newValue,
                    type: buttonType,
                }));
                if (buttonType == "item") {
                    OSClothing.ResetItemTexture(this, clothingCategory);
                }
            } else {
                if (buttonType == "item") {
                    var buttonMax = $(this).parent().find('[data-headertype="item-header"]').data('maxItem');
                    if (clothingCategory == "accessory" && newValue == 13) {
                        $(inputElem).val(14);
                        $.post('http://IND-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: 14,
                            type: buttonType,
                        }));
                    } else {
                        if (newValue <= parseInt(buttonMax)) {
                            $(inputElem).val(newValue);
                            $.post('http://IND-clothing/updateSkin', JSON.stringify({
                                clothingType: clothingCategory,
                                articleNumber: newValue,
                                type: buttonType,
                            }));
                        }
                    }
                    OSClothing.ResetItemTexture(this, clothingCategory);
                } else {
                    var buttonMax = $(this).parent().find('[data-headertype="texture-header"]').data('maxTexture');
                    if (newValue <= parseInt(buttonMax)) {
                        $(inputElem).val(newValue);
                        $.post('http://IND-clothing/updateSkin', JSON.stringify({
                            clothingType: clothingCategory,
                            articleNumber: newValue,
                            type: buttonType,
                        }));
                    }
                }
            }
        }
    }
});

$(document).on('click', '.clothing-menu-option-item-left', function(e){
    e.preventDefault();

    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) - 1;

    if (canChange) {
        if (hasTracker && clothingCategory == "accessory") {
            $.post('http://IND-clothing/TrackerError');
            return
        } else {
            if (clothingCategory == "model") {
                if (newValue != 0) {
                    $(inputElem).val(newValue);
                    $.post('http://IND-clothing/setCurrentPed', JSON.stringify({ped: newValue}), function(model){
                        $("#current-model").html("<p>"+model+"</p>")
                    });
                    canChange = true;
                    OSClothing.ResetValues();
                }
            } else {
                if (buttonType == "item") {
                    if (newValue >= clothingCategorys[clothingCategory].defaultItem) {
                        if (clothingCategory == "accessory" && newValue == 13) {
                            $(inputElem).val(12);
                            $.post('http://IND-clothing/updateSkin', JSON.stringify({
                                clothingType: clothingCategory,
                                articleNumber: 12,
                                type: buttonType,
                            }));
                        } else {
                            $(inputElem).val(newValue);
                            $.post('http://IND-clothing/updateSkin', JSON.stringify({
                                clothingType: clothingCategory,
                                articleNumber: newValue,
                                type: buttonType,
                            }));
                        }
                    }
                    OSClothing.ResetItemTexture(this, clothingCategory);
                } else {
                    if (newValue >= clothingCategorys[clothingCategory].defaultTexture) {
                        if (clothingCategory == "accessory" && newValue == 13) {
                            $(inputElem).val(12);
                            $.post('http://IND-clothing/updateSkin', JSON.stringify({
                                clothingType: clothingCategory,
                                articleNumber: 12,
                                type: buttonType,
                            }));
                        } else {
                            $(inputElem).val(newValue);
                            $.post('http://IND-clothing/updateSkin', JSON.stringify({
                                clothingType: clothingCategory,
                                articleNumber: newValue,
                                type: buttonType,
                            }));
                        }
                    }
                }
            }
        }
    }
});

var changingCat = null;

function ChangeUp() {
    var clothingCategory = $(changingCat).parent().parent().data('type');
    var buttonType = $(changingCat).data('type');
    var inputVal = parseFloat($(changingCat).val());

    if (clothingCategory == "accessory" && inputVal + 1 == 13) {
        $(changingCat).val(14 - 1)
    }
}

function ChangeDown() {
    var clothingCategory = $(changingCat).parent().parent().data('type');
    var buttonType = $(changingCat).data('type');
    var inputVal = parseFloat($(changingCat).val());


    if (clothingCategory == "accessory" && inputVal - 1 == 13) {
        $(changingCat).val(12 + 1)
    }
}

$(document).on('change', '.item-number', function(){
    var clothingCategory = $(this).parent().parent().data('type');
    var buttonType = $(this).data('type');
    var inputVal = $(this).val();

    changingCat = this;

    if (hasTracker && clothingCategory == "accessory") {
        $.post('http://IND-clothing/TrackerError');
        $(this).val(13);
        return
    } else {
        if (clothingCategory == "accessory" && inputVal == 13) {
            $(this).val(12);
            return
        } else {
            $.post('http://IND-clothing/updateSkinOnInput', JSON.stringify({
                clothingType: clothingCategory,
                articleNumber: parseFloat(inputVal),
                type: buttonType,
            }));
        }
    }
});

$(document).on('click', '.clothing-menu-header-camera-btn', function(e){
    e.preventDefault();

    var camValue = parseFloat($(this).data('value'));

    if (selectedCam == null) {
        $(this).addClass("selected-cam");
        $.post('http://IND-clothing/setupCam', JSON.stringify({
            value: camValue
        }));
        selectedCam = this;
    } else {
        if (selectedCam == this) {
            $(selectedCam).removeClass("selected-cam");
            $.post('http://IND-clothing/setupCam', JSON.stringify({
                value: 0
            }));

            selectedCam = null;
        } else {
            $(selectedCam).removeClass("selected-cam");
            $(this).addClass("selected-cam");
            $.post('http://IND-clothing/setupCam', JSON.stringify({
                value: camValue
            }));

            selectedCam = this;
        }
    }
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 68: // D
            $.post('http://IND-clothing/rotateRight');
            break;
        case 65: // A
            $.post('http://IND-clothing/rotateLeft');
            break;
        case 38: // UP
            ChangeUp();
            break;
        case 40: // DOWN
            ChangeDown();
            break;
    }
});

OSClothing.ToggleChange = function(bool) {
    canChange = bool;
}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                OSClothing.Open(event.data);
                break;
            case "close":
                OSClothing.Close();
                break;
            case "updateMax":
                OSClothing.SetMaxValues(event.data.maxValues);
                break;
            case "reloadMyOutfits":
                OSClothing.ReloadOutfits(event.data.outfits);
                break;
            case "toggleChange":
                OSClothing.ToggleChange(event.data.allow);
                break;
            case "ResetValues":
                OSClothing.ResetValues();
                break;
        }
    })
});

OSClothing.ReloadOutfits = function(outfits) {
    $(".clothing-menu-myOutfits-container").html("");
    $.each(outfits, function(index, outfit){
        var elem = '<div class="clothing-menu-option" data-myOutfit="'+(index + 1)+'"> <div class="clothing-menu-option-header"><p>'+outfit.outfitname+'</p></div><div class="clothing-menu-myOutfit-option-button"><p>Select</p></div><div class="clothing-menu-myOutfit-option-button-remove"><p>Delete</p></div></div>'
        $(".clothing-menu-myOutfits-container").append(elem)
        
        $("[data-myOutfit='"+(index + 1)+"']").data('myOutfitData', outfit)
    });
}

$(document).on('click', "#save-menu", function(e){
    e.preventDefault();
    OSClothing.Close();
    $.post('http://IND-clothing/saveClothing');
});

$(document).on('click', "#cancel-menu", function(e){
    e.preventDefault();
    OSClothing.Close();
    $.post('http://IND-clothing/resetOutfit');
});

OSClothing.SetCurrentValues = function(clothingValues) {
    $.each(clothingValues, function(i, item){
        var itemCats = $(".clothing-menu-container").find('[data-type="'+i+'"]');
        var input = $(itemCats).find('input[data-type="item"]');
        var texture = $(itemCats).find('input[data-type="texture"]');

        $(input).val(item.item);
        $(texture).val(item.texture);
    });
}

OSClothing.Open = function(data) {
    clothingCategorys = data.currentClothing;

    if (data.hasTracker) {
        hasTracker = true;
    } else {
        hasTracker = false;
    }

    $(".change-camera-buttons").fadeIn(150);

    $(".clothing-menu-roomOutfits-container").css("display", "none");
    $(".clothing-menu-myOutfits-container").css("display", "none");
    $(".clothing-menu-character-container").css("display", "none");
    $(".clothing-menu-clothing-container").css("display", "none");
    $(".clothing-menu-haircut-container").css("display", "none");
    $(".clothing-menu-accessoires-container").css("display", "none");
    $(".clothing-menu-container").css({"display":"block"}).animate({right: 0,}, 200);
    $(".container").css({"display":"block"});
    OSClothing.SetMaxValues(data.maxValues);
    $(".clothing-menu-header").html("");
    OSClothing.SetCurrentValues(data.currentClothing);
    $(".clothing-menu-roomOutfits-container").html("");
    $(".clothing-menu-myOutfits-container").html("");
    $.each(data.menus, function(i, menu){
        if (menu.selected) {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab selected" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
            $(".clothing-menu-"+menu.menu+"-container").css({"display":"block"});
            selectedTab = "." + menu.menu + "Tab";
            lastCategory = menu.menu;

        } else {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn '+menu.menu+'Tab" data-category="'+menu.menu+'"><p>'+menu.label+'</p></div>')
        }

        if (menu.menu == "roomOutfits") {
            $.each(menu.outfits, function(index, outfit){
                var elem = '<div class="clothing-menu-option" data-outfit="'+(index + 1)+'"> <div class="clothing-menu-option-header"><p>'+outfit.outfitLabel+'</p></div> <div class="clothing-menu-outfit-option-button"><p>Select Outfit</p></div> </div>'
                $(".clothing-menu-roomOutfits-container").append(elem)
                
                $("[data-outfit='"+(index + 1)+"']").data('outfitData', outfit)
            });
        }

        if (menu.menu == "myOutfits") {
            $.each(menu.outfits, function(index, outfit){
                var elem = '<div class="clothing-menu-option" data-myOutfit="'+(index + 1)+'"> <div class="clothing-menu-option-header"><p>'+outfit.outfitname+'</p></div><div class="clothing-menu-myOutfit-option-button"><p>Select</p></div><div class="clothing-menu-myOutfit-option-button-remove"><p>Delete</p></div></div>'
                $(".clothing-menu-myOutfits-container").append(elem)
                
                $("[data-myOutfit='"+(index + 1)+"']").data('myOutfitData', outfit)
            });
        }
    });

    var menuWidth = (100 / data.menus.length)

    $(".clothing-menu-header-btn").css("width", menuWidth + "%");
}

$(document).on('click', '.clothing-menu-outfit-option-button', function(e){
    e.preventDefault();

    var oData = $(this).parent().data('outfitData');

    $.post('http://IND-clothing/selectOutfit', JSON.stringify({
        outfitData: oData.outfitData,
        outfitName: oData.outfitLabel
    }))
});

$(document).on('click', '.clothing-menu-myOutfit-option-button', function(e){
    e.preventDefault();

    var outfitData = $(this).parent().data('myOutfitData');

    $.post('http://IND-clothing/selectOutfit', JSON.stringify({
        outfitData: outfitData.skin,
        outfitName: outfitData.outfitname,
        outfitId: outfitData.outfitId,
    }))
});

$(document).on('click', '.clothing-menu-myOutfit-option-button-remove', function(e){
    e.preventDefault();

    var outfitData = $(this).parent().data('myOutfitData');

    $.post('http://IND-clothing/removeOutfit', JSON.stringify({
        outfitData: outfitData.skin,
        outfitName: outfitData.outfitname,
        outfitId: outfitData.outfitId,
    }));
});

OSClothing.Close = function() {
    $.post('http://IND-clothing/close');
    $(".change-camera-buttons").fadeOut(150);
    $(".clothing-menu-roomOutfits-container").css("display", "none");
    $(".clothing-menu-myOutfits-container").css("display", "none");
    $(".clothing-menu-character-container").css("display", "none");
    $(".clothing-menu-clothing-container").css("display", "none");
    $(".clothing-menu-haircut-container").css("display", "none");
    $(".clothing-menu-accessoires-container").css("display", "none");
    $(".clothing-menu-header").html("");

    $(selectedCam).removeClass('selected-cam');
    $(selectedTab).removeClass("selected");
    selectedCam = null;
    selectedTab = null;
    lastCategory = null;
    $(".clothing-menu-container").css({"display":"block"}).animate({right: "-25vw",}, 200, function(){
        $(".clothing-menu-container").css({"display":"none"});
        $(".container").css({"display":"none"});
    });
}

OSClothing.SetMaxValues = function(maxValues) {
    $.each(maxValues, function(i, cat){
        if (cat.type == "character") {
            var containers = $(".clothing-menu-character-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "hair") {
            var containers = $(".clothing-menu-haircut-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        } else if (cat.type == "accessoires") {
            var containers = $(".clothing-menu-accessoires-container").find('[data-type="'+i+'"]');
            var itemMax = $(containers).find('[data-headertype="item-header"]');
            var headerMax = $(containers).find('[data-headertype="texture-header"]');
    
            $(itemMax).data('maxItem', maxValues[containers.data('type')].item)
            $(headerMax).data('maxTexture', maxValues[containers.data('type')].texture)
    
            $(itemMax).html("<p>Item: " + maxValues[containers.data('type')].item + "</p>")
            $(headerMax).html("<p>Texture: " + maxValues[containers.data('type')].texture + "</p>")
        }
    })
}

OSClothing.ResetValues = function() {
    $.each(clothingCategorys, function(i, cat){
        var itemCats = $(".clothing-menu-container").find('[data-type="'+i+'"]');
        var input = $(itemCats).find('input[data-type="item"]');
        var texture = $(itemCats).find('input[data-type="texture"]');
        
        $(input).val(cat.defaultItem);
        $(texture).val(cat.defaultTexture);
    })
}

$(document).on('click', '#save-outfit', function(e){
    e.preventDefault();

    $(".clothing-menu-container").css({"display":"block"}).animate({right: "-25vw",}, 200, function(){
        $(".clothing-menu-container").css({"display":"none"});
    });

    $(".clothing-menu-save-outfit-name").fadeIn(150);
});

$(document).on('click', '#save-outfit-save', function(e){
    e.preventDefault();

    $(".clothing-menu-container").css({"display":"block"}).animate({right: 0,}, 200);
    $(".clothing-menu-save-outfit-name").fadeOut(150);

    $.post('http://IND-clothing/saveOutfit', JSON.stringify({
        outfitName: $("#outfit-name").val()
    }));
});

$(document).on('click', '#cancel-outfit-save', function(e){
    e.preventDefault();

    $(".clothing-menu-container").css({"display":"block"}).animate({right: 0,}, 200);
    $(".clothing-menu-save-outfit-name").fadeOut(150);
});

$(document).on('click', '.change-camera-button', function(e){
    e.preventDefault();

    var rotationType = $(this).data('rotation');

    $.post('http://IND-clothing/rotateCam', JSON.stringify({
        type: rotationType
    }))
});


// OSClothing.Open()