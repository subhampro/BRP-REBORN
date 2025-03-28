local holdingCam = false
local holdingMic = false
local holdingBmic = false
local camModel = "prop_v_cam_01"
local camanimDict = "missfinale_c2mcs_1"
local camanimName = "fin_c2_mcs_1_camman"
local micModel = "p_ing_microphonel_01"
local micanimDict = "missheistdocksprep1hold_cellphone"
local micanimName = "hold_cellphone"
local bmicModel = "prop_v_bmike_01"
local bmicanimDict = "missfra1"
local bmicanimName = "mcs2_crew_idle_m_boom"
local bmic_net = nil
local mic_net = nil
local cam_net = nil
local UI = {
	x = 0.000,
	y = -0.001,
}
local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0
local speed_lr = 8.0
local speed_ud = 8.0
local camera = false
local fov = (fov_max + fov_min) * 0.5
local new_z
local movcamera
local newscamera


--FUNCTIONS--
local function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

local function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		local new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

local function HandleZoom(cam)
	local lPed = PlayerPedId()
	if not (IsPedSittingInAnyVehicle(lPed)) then

		if IsControlJustPressed(0, 241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0, 242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov - current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
	else
		if IsControlJustPressed(0, 17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0, 16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov - current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)
	end
end

local function drawRct(x, y, width, height, r, g, b, a)
	DrawRect(x + width / 2, y + height / 2, width, height, r, g, b, a)
end

local function DisplayNotification(string)
	SetTextComponentFormat("STRING")
	AddTextComponentString(string)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

---------------------------------------------------------------------------
-- Toggling Cam --
---------------------------------------------------------------------------

RegisterNetEvent("Cam:ToggleCam", function()
	if not holdingCam then
		RequestModel(GetHashKey(camModel))
		while not HasModelLoaded(GetHashKey(camModel)) do
			Wait(100)
		end

		local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
		local camspawned = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
		Wait(1000)
		local netid = ObjToNet(camspawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(camspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0,
			0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
		TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		cam_net = netid
		holdingCam = true
		DisplayNotification(Lang:t("text.weazle_overlay"))
	else
		ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
		DetachEntity(NetToObj(cam_net), 1, 1)
		DeleteEntity(NetToObj(cam_net))
		cam_net = nil
		holdingCam = false
	end
end)

CreateThread(function()
	while true do
		if PlayerJob.name == "reporter" then
			if holdingCam then
				while not HasAnimDictLoaded(camanimDict) do
					RequestAnimDict(camanimDict)
					Wait(100)
				end

				if not IsEntityPlayingAnim(PlayerPedId(), camanimDict, camanimName, 3) then
					TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
					TaskPlayAnim(GetPlayerPed(PlayerId()), camanimDict, camanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
				end

				DisablePlayerFiring(PlayerId(), true)
				DisableControlAction(0, 25, true) -- disable aim
				DisableControlAction(0, 44, true) -- INPUT_COVER
				DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- Movie Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
		if PlayerJob.name == "reporter" then
			if holdingCam then
				if IsControlJustReleased(1, 244) then
					movcamera = true
					SetTimecycleModifier("default")
					SetTimecycleModifierStrength(0.3)
					local scaleform = RequestScaleformMovie("security_camera")
					while not HasScaleformMovieLoaded(scaleform) do
						Wait(10)
					end

					local lPed = PlayerPedId()
					local vehicle = GetVehiclePedIsIn(lPed)
					local cam1 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

					AttachCamToEntity(cam1, lPed, 0.0, 0.0, 1.0, true)
					SetCamRot(cam1, 2.0, 1.0, GetEntityHeading(lPed))
					SetCamFov(cam1, fov)
					RenderScriptCams(true, false, 0, 1, 0)
					PushScaleformMovieFunction(scaleform, "security_camera")
					PopScaleformMovieFunctionVoid()

					while movcamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
						if IsControlJustPressed(0, 177) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							movcamera = false
						end

						SetEntityRotation(lPed, 0, 0, new_z, 2, true)
						local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
						CheckInputRotation(cam1, zoomvalue)
						HandleZoom(cam1)
						HideHUDThisFrame()
						drawRct(UI.x + 0.0, UI.y + 0.0, 1.0, 0.15, 0, 0, 0, 255) -- Top Bar
						DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
						drawRct(UI.x + 0.0, UI.y + 0.85, 1.0, 0.16, 0, 0, 0, 255) -- Bottom Bar
						local camHeading = GetGameplayCamRelativeHeading()
						local camPitch = GetGameplayCamRelativePitch()
						if camPitch < -70.0 then
							camPitch = -70.0
						elseif camPitch > 42.0 then
							camPitch = 42.0
						end
						camPitch = (camPitch + 70.0) / 112.0
						if camHeading < -180.0 then
							camHeading = -180.0
						elseif camHeading > 180.0 then
							camHeading = 180.0
						end
						camHeading = (camHeading + 180.0) / 360.0
						SetTaskMoveNetworkSignalFloat(PlayerPedId(), "Pitch", camPitch)
						SetTaskMoveNetworkSignalFloat(PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
						Wait(1)
					end
					movcamera = false
					ClearTimecycleModifier()
					fov = (fov_max + fov_min) * 0.5
					RenderScriptCams(false, false, 0, 1, 0)
					SetScaleformMovieAsNoLongerNeeded(scaleform)
					DestroyCam(cam1, false)
					SetNightvision(false)
					SetSeethrough(false)
				end
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- News Cam --
---------------------------------------------------------------------------

CreateThread(function()
	while true do
		if PlayerJob.name == "reporter" then
			if holdingCam then
				if IsControlJustReleased(1, 38) then
					newscamera = true
					SetTimecycleModifier("default")
					SetTimecycleModifierStrength(0.3)
					local scaleform = RequestScaleformMovie("security_camera")
					local scaleform2 = RequestScaleformMovie("breaking_news")
					while not HasScaleformMovieLoaded(scaleform) do
						Wait(10)
					end
					while not HasScaleformMovieLoaded(scaleform2) do
						Wait(10)
					end
					local lPed = PlayerPedId()
					local vehicle = GetVehiclePedIsIn(lPed)
					local cam2 = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
					local msg = Lang:t("text.breaking_news")
					local title = Lang:t("text.title_breaking_news")
					local bottom = Lang:t("text.bottom_breaking_news")

					AttachCamToEntity(cam2, lPed, 0.0, 0.0, 1.0, true)
					SetCamRot(cam2, 2.0, 1.0, GetEntityHeading(lPed))
					SetCamFov(cam2, fov)
					RenderScriptCams(true, false, 0, 1, 0)
					PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
					PushScaleformMovieFunction(scaleform2, "breaking_news")
					PopScaleformMovieFunctionVoid()

					BeginScaleformMovieMethod(scaleform2, 'SET_TEXT')
					PushScaleformMovieMethodParameterString(msg)
					PushScaleformMovieMethodParameterString(bottom)
					EndScaleformMovieMethod()

					BeginScaleformMovieMethod(scaleform2, 'SET_SCROLL_TEXT')
					PushScaleformMovieMethodParameterInt(0) -- top ticker
					PushScaleformMovieMethodParameterInt(0) -- Since this is the first string, start at 0
					PushScaleformMovieMethodParameterString(title)

					EndScaleformMovieMethod()

					BeginScaleformMovieMethod(scaleform2, 'DISPLAY_SCROLL_TEXT')
					PushScaleformMovieMethodParameterInt(0) -- Top ticker
					PushScaleformMovieMethodParameterInt(0) -- Index of string

					EndScaleformMovieMethod()
					while newscamera and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == vehicle) and true do
						if IsControlJustPressed(1, 177) then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							newscamera = false
						end
						SetEntityRotation(lPed, 0, 0, new_z, 2, true)
						local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
						CheckInputRotation(cam2, zoomvalue)
						HandleZoom(cam2)
						HideHUDThisFrame()
						DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
						DrawScaleformMovie(scaleform2, 0.5, 0.63, 1.0, 1.0, 255, 255, 255, 255)

						local camHeading = GetGameplayCamRelativeHeading()
						local camPitch = GetGameplayCamRelativePitch()
						if camPitch < -70.0 then
							camPitch = -70.0
						elseif camPitch > 42.0 then
							camPitch = 42.0
						end
						camPitch = (camPitch + 70.0) / 112.0
						if camHeading < -180.0 then
							camHeading = -180.0
						elseif camHeading > 180.0 then
							camHeading = 180.0
						end
						camHeading = (camHeading + 180.0) / 360.0
						SetTaskMoveNetworkSignalFloat(PlayerPedId(), "Pitch", camPitch)
						SetTaskMoveNetworkSignalFloat(PlayerPedId(), "Heading", camHeading * -1.0 + 1.0)
						Wait(1)
					end
					newscamera = false
					ClearTimecycleModifier()
					fov = (fov_max + fov_min) * 0.5
					RenderScriptCams(false, false, 0, 1, 0)
					SetScaleformMovieAsNoLongerNeeded(scaleform)
					DestroyCam(cam2, false)
					SetNightvision(false)
					SetSeethrough(false)
				end
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
--B Mic --
---------------------------------------------------------------------------

RegisterNetEvent("Mic:ToggleBMic", function()
	if not holdingBmic then
		RequestModel(GetHashKey(bmicModel))
		while not HasModelLoaded(GetHashKey(bmicModel)) do
			Wait(100)
		end
		local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
		local bmicspawned = CreateObject(GetHashKey(bmicModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
		Wait(1000)
		local netid = ObjToNet(bmicspawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(bmicspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.08,
			0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
		TaskPlayAnim(GetPlayerPed(PlayerId()), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		bmic_net = netid
		holdingBmic = true
	else
		ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
		DetachEntity(NetToObj(bmic_net), 1, 1)
		DeleteEntity(NetToObj(bmic_net))
		bmic_net = nil
		holdingBmic = false
	end
end)

CreateThread(function()
	while true do
		if PlayerJob.name == "reporter" then
			if holdingBmic then
				while not HasAnimDictLoaded(bmicanimDict) do
					RequestAnimDict(bmicanimDict)
					Wait(100)
				end
				if not IsEntityPlayingAnim(PlayerPedId(), bmicanimDict, bmicanimName, 3) then
					TaskPlayAnim(PlayerPedId(), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
					TaskPlayAnim(PlayerPedId(), bmicanimDict, bmicanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
				end
				DisablePlayerFiring(PlayerId(), true)
				DisableControlAction(0, 25, true) -- disable aim
				DisableControlAction(0, 44, true) -- INPUT_COVER
				DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
				SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
				if IsPedInAnyVehicle(PlayerPedId(), false) or INDCore.Functions.GetPlayerData().metadata["ishandcuffed"] or holdingMic then
					ClearPedSecondaryTask(PlayerPedId())
					DetachEntity(NetToObj(bmic_net), 1, 1)
					DeleteEntity(NetToObj(bmic_net))
					bmic_net = nil
					holdingBmic = false
				end
				Wait(7)
			else
				Wait(100)
			end
		else
			Wait(1000)
		end
	end
end)

---------------------------------------------------------------------------
-- Events --
---------------------------------------------------------------------------

-- Activate camera
RegisterNetEvent('camera:Activate', function()
	camera = not camera
end)

---------------------------------------------------------------------------
-- Toggling Mic --
---------------------------------------------------------------------------
RegisterNetEvent("Mic:ToggleMic", function()
	if not holdingMic then
		RequestModel(GetHashKey(micModel))
		while not HasModelLoaded(GetHashKey(micModel)) do
			Wait(100)
		end

		while not HasAnimDictLoaded(micanimDict) do
			RequestAnimDict(micanimDict)
			Wait(100)
		end
		local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
		local micspawned = CreateObject(GetHashKey(micModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
		Wait(1000)
		local netid = ObjToNet(micspawned)
		SetNetworkIdExistsOnAllMachines(netid, true)
		NetworkSetNetworkIdDynamic(netid, true)
		SetNetworkIdCanMigrate(netid, false)
		AttachEntityToEntity(micspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), 0.055,
			0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
		TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
		TaskPlayAnim(GetPlayerPed(PlayerId()), micanimDict, micanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
		mic_net = netid
		holdingMic = true
	else
		ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
		DetachEntity(NetToObj(mic_net), 1, 1)
		DeleteEntity(NetToObj(mic_net))
		mic_net = nil
		holdingMic = false
	end
end)
