BIXI Montreal station status intermediary API

This is an intermediary API created to retrieve more concise responses from the BIXI Montreal original station status API (https://api-core.bixi.com/gbfs/en/station_status.json).

The original API's response is about 155kb, being quite hard to handle by microcontrollers.

Endpoints:

/stations/:id
Response: the station object with the specified ID

/stations/:id/bikes
Response: number of available bikes (including e-bikes) at the given station

/stations/:id/docks
Response: number of available docks at the given station
