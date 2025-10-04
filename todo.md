
- Prevent cursors from going off screen and from placing units on enemy side

- Game over screen
	- I'm already checking for game overs in game.gd

- Update deckbuilding screen visuals

- More cards
    - Elixir farming buildings

- Draw cooldown + draw cooldown UI visual

- Sounds/Music

- Sprites for each unit and towers. These can just be basic shapes

- 	Signal servering effect. When a signal is severed, that unit loses half of its stats (damage, speed, cooldown)
	- Add "severed" property to unit class. If severed is true, then don't draw line to nearest friendly tower
	- Maybe also add a visual to show when a unit's signal is severed, particle effect or maybe just stick a sprite on them (like a warning png)
    - Any unit or spell that severs signals needs to rebuff the affected units when it goes away, and set severed back to false

- Figure out a way to better incorporate the theme
	Units have a line drawn from them to their target, and a line drawn to their nearest friendly tower
	The lines represent their "signals" 
	Then mixing these signals can make enemy units friendly, or switch targets
	Units which are closer to their "radio towers" have stronger signal and improved stats
    Spells:
		- Improve signal strength in an area, buffing friendly units
		- Decrease signal strength for enemy units in an area
		- "Scramble" signals, making enemies target random units
		- EMP: Temporarily sever all signals of units in an area
	Buildings:
		- AOE field that buffs units (antennas)
		- Spawner whose minions provide minor AOE buffs/debuffs
		- Jammer which severs enemy signals 
        - Backdoor: a one-way teleporter type building which allows friendly units to come out the other side. I would reflect the position across the y axis so an additional version is placed automatically

- Provide at least three viable builds + multipurpose units that could fit into multiple builds
    - Rush: cheap units
    - Defensive: mainly buildings
    
