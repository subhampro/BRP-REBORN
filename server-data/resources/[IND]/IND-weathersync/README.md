# IND-weathersync
Synced weather and time for IND-Core Framework :sunrise:

# License

    INDCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>


## Dependencies
- [IND-core](https://github.com/qbcore-framework/IND-core)

## Features
- Syncs the weather for all players

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Add the following code to your server.cfg/resouces.cfg
```
ensure IND-core
ensure IND-weathersync
```

## Configuration
You can adjust available weather and defaults in `config.lua`
to adjust weather patterns you need to modify nextWeatherStage() in `server/server.lua`



## Commands

`/freezetime` - Toggle time progression

`/freezeweather` - Toggle dynamic weather

`/weather [type]` - Set weather

`/blackout` - Toggle blackout

`/morning` - Set time to 9am

`/noon` - Set time to 12pm

`/evening` - Set time to 6pm

`/night` - Set time to 11pm

`/time [hour] (minute)` - Set time to whatever you want

## Exports

### nextWeatherStage
Triggers event to switch weather to next stage
```lua
-- LUA EXAMPLE
local success = exports["IND-weathersync"]:nextWeatherStage();
```
```js
// JAVASCRIPT EXAMPLE
const success = global.exports["IND-weathersync"].nextWeatherStage();
```


### setWeather [type]
Switch to a specified weather type from Config.AvailableWeatherTypes
```lua
-- LUA EXAMPLE
local success = exports["IND-weathersync"]:setWeather("snow");
```
```js
// JAVASCRIPT EXAMPLE
const success = global.exports["IND-weathersync"].setWeather("snow");
```


### setTime [hour] (minute)
Sets sun position based on time to specified
```lua
-- LUA EXAMPLE
local success = exports["IND-weathersync"]:setTime(8, 10); -- 8:10 AM
```
```js
// JAVASCRIPT EXAMPLE
const success = global.exports["IND-weathersync"].setTime(15, 30); // 3:30PM
```


### setBlackout (true|false)
Sets or toggles blackout state and returns the state
```lua
-- LUA EXAMPLE
local newStatus = exports["IND-weathersync"]:setBlackout(); -- Toggle
```
```js
// JAVASCRIPT EXAMPLE
const newStatus = global.exports["IND-weathersync"].setBlackout(true); // Enable
```


### setTimeFreeze (true|false)
Sets or toggles time freeze state and returns the state
```lua
-- LUA EXAMPLE
local newStatus = exports["IND-weathersync"]:setTimeFreeze(); -- Toggle
```
```js
// JAVASCRIPT EXAMPLE
const newStatus = global.exports["IND-weathersync"].setTimeFreeze(true); // Enable
```


### setDynamicWeather (true|false)
Sets or toggles dynamic weather state and returns the state
```lua
-- LUA EXAMPLE
local newStatus = exports["IND-weathersync"]:setDynamicWeather(); -- Toggle
```
```js
// JAVASCRIPT EXAMPLE
const newStatus = global.exports["IND-weathersync"].setDynamicWeather(true); // Enable
```


### getBlackoutState
Returns if blackout is enabled or disabled
```lua
-- LUA EXAMPLE
local state = exports["IND-weathersync"]:getBlackoutState();
```
```js
// JAVASCRIPT EXAMPLE
const state = global.exports["IND-weathersync"].getBlackoutState();
```


### getTimeFreezeState
Returns if time progression is enabled or disabled
```lua
-- LUA EXAMPLE
local state = exports["IND-weathersync"]:getTimeFreezeState();
```
```js
// JAVASCRIPT EXAMPLE
const state = global.exports["IND-weathersync"].getTimeFreezeState();
```


### getWeatherState
Returns the current weather type
```lua
-- LUA EXAMPLE
local currentWeather = exports["IND-weathersync"]:getWeatherState();
```
```js
// JAVASCRIPT EXAMPLE
const currentWeather = global.exports["IND-weathersync"].getWeatherState();
```


### getDynamicWeather
Returns if time progression is enabled or disabled
```lua
-- LUA EXAMPLE
local state = exports["IND-weathersync"]:getDynamicWeather();
```
```js
// JAVASCRIPT EXAMPLE
const state = global.exports["IND-weathersync"].getDynamicWeather();
```


## Events


`IND-weathersync:server:RequestStateSync` - Sync time and weather for everyone

`IND-weathersync:server:setWeather` [type] - Set Weather type (List in Config)

`IND-weathersync:server:setTime` [hour] (minute) - Set simulated time

`IND-weathersync:server:toggleBlackout` (true|false) - Enable, disable or toggle blackout

`IND-weathersync:server:toggleFreezeTime` (true|false) (minute) - Enable, disable or toggle time progression

`IND-weathersync:server:toggleDynamicWeather` (true|false) - Enable, disable or toggle dynamic weather

