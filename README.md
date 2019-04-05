===
BIXI Montreal station status intermediary API
===

This is an intermediary API created to retrieve more concise responses from the BIXI Montreal original station status API (https://api-core.bixi.com/gbfs/en/station_status.json).

The original API's response is about 155kb, being quite hard to handle by microcontrollers.

---
Base URL
---

http://bixi-station-status-api.herokuapp.com

---
Endpoints:
---

/stations/:terminal_id
Response: the station object with the specified terminal ID (e.g. 6137). You can see the stations' terminal IDs on the Bixi website.

/stations/:terminal_id/bikes
Response: number of available bikes (including e-bikes) at the given station. You can include multiple stations in one single request by inputting their numbers separated by `-` (e.g. /stations/6001-6018-6411/bikes).

/stations/:terminal_id/docks
Response: number of available docks at the given station. You can include multiple stations as mentioned above.
