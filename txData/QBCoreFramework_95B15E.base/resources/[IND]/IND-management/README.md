# IND-management

New IND-bossmenu / IND-gangmenu converted into one resource using IND-menu and IND-input, with SQL support for society funds!

## Dependencies
- [IND-core](https://github.com/qbcore-framework/IND-core)
- [IND-smallresources](https://github.com/qbcore-framework/IND-smallresources) (For the Logs)
- [IND-input](https://github.com/qbcore-framework/IND-input)
- [IND-menu](https://github.com/qbcore-framework/IND-menu)
- [IND-inventory](https://github.com/qbcore-framework/IND-inventory)
- [IND-clothing](https://github.com/qbcore-framework/IND-clothing)

## Screenshots
![image](https://i.imgur.com/9yiQZDX.png)
![image](https://i.imgur.com/MRMWeqX.png)

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- IF NEW SERVER: Import `IND-management.sql` in your database
- IF EXISTING SERVER: Import `IND-management_upgrade.sql` in your database
- Edit config.lua with coords
- Restart Script / Server

## ATTENTION
### YOU NEED TO CREATE A ROW IN DATABASE WITH NAME OF SOCIETY IN MANAGEMENT_FUNDS TABLE IF YOU HAVE CUSTOM JOBS / GANGS
![database](https://i.imgur.com/6cd3NLU.png)

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
