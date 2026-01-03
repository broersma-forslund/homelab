# House Modes & Scenes Documentation

This document describes all the house modes (scripts) and room scenes available in the Home Assistant configuration.

## Table of Contents
- [House Modes (Scripts)](#house-modes-scripts)
- [Room-Specific Scenes](#room-specific-scenes)
- [Usage Guide](#usage-guide)
- [Future Improvements](#future-improvements)

---

## House Modes (Scripts)

House modes are orchestrated scripts that control multiple rooms at once to create cohesive lighting and ambiance throughout the home. All modes are defined in `/configuration/scripts/house_modes.yaml`.

### 1. Home Mode (`home_mode`)
**Icon:** `mdi:home`  
**Purpose:** Standard daytime presence mode

**Activated Scenes:**
- Living Room: Day
- Kitchen: Day

**Use Cases:**
- General daytime use when home
- Working from home (non-focused work)
- Standard family activities

---

### 2. Away Mode (`away_mode`)
**Icon:** `mdi:home-export-outline`  
**Purpose:** All lights off for when nobody is home

**Activated Scenes:**
- All rooms: Off

**Use Cases:**
- Leaving the house
- Energy conservation
- Security (paired with automation)

---

### 3. Sleep/Night Mode (`home_sleep`)
**Icon:** `mdi:power-sleep`  
**Purpose:** Prepare the house for sleep

**Activated Scenes:**
- Living Room: Off
- Kitchen: Off
- Bedroom: Night (dim, warm)
- Bathroom: Night (dim, warm)
- Office: Off
- Shower: Off
- Mechanical Room: Off

**Use Cases:**
- Bedtime routine
- Night-time bathroom visits
- Minimal light pollution for sleep

---

### 4. Morning Mode (`morning_mode`)
**Icon:** `mdi:weather-sunset-up`  
**Purpose:** Energizing morning routine

**Activated Scenes:**
- Bedroom: Morning (bright, cool)
- Bathroom: Energize (bright, cool)
- Kitchen: Morning (bright, cool)

**Use Cases:**
- Wake-up routine
- Morning preparation
- Energizing start to the day

---

### 5. Guests Mode (`guests_mode`)
**Icon:** `mdi:account-multiple`  
**Purpose:** Welcoming atmosphere for visitors

**Activated Scenes:**
- Living Room: Day
- Kitchen: Day
- Bathroom: Day

**Use Cases:**
- Having guests over
- Dinner parties
- Social gatherings

---

### 6. Vacation Mode (`vacation_mode`)
**Icon:** `mdi:beach`  
**Purpose:** Energy-saving mode for extended absences

**Activated Scenes:**
- All rooms: Off

**Use Cases:**
- Extended time away from home
- Maximum energy conservation
- Can be paired with random lighting automations for security

---

### 7. Movie Night (`movie_night`)
**Icon:** `mdi:movie`  
**Purpose:** Cinema-like atmosphere for watching movies

**Activated Scenes:**
- Living Room: Movie (dim ambient, warm)
- Kitchen: Off

**Use Cases:**
- Watching movies or TV shows
- Gaming sessions
- Minimal screen glare

---

### 8. Cleaning Mode (`cleaning_mode`)
**Icon:** `mdi:spray-bottle`  
**Purpose:** Bright, clear lighting for cleaning tasks

**Activated Scenes:**
- Living Room: Day (bright)
- Kitchen: Cleaning (bright, cool)
- Mechanical Room: Cleaning (bright, cool)

**Use Cases:**
- House cleaning
- Detailed work that requires visibility
- Maintenance tasks

---

### 9. Energize Mode (`energize_mode`)
**Icon:** `mdi:lightning-bolt`  
**Purpose:** High-energy morning boost

**Activated Scenes:**
- Kitchen: Morning (bright, cool 5000K)
- Bathroom: Energize (bright, cool 5000K)
- Shower: Morning (bright, cool 5000K)

**Use Cases:**
- Quick morning routine
- Need an energy boost
- Early morning activities

---

### 10. Work Mode (`work_mode`)
**Icon:** `mdi:briefcase`  
**Purpose:** Focused work environment

**Activated Scenes:**
- Office: Work (bright, cool, focused)
- Living Room: Off
- Kitchen: Off

**Use Cases:**
- Remote work
- Focused tasks requiring concentration
- Study sessions
- Minimizing distractions

---

### 11. Relax/Wellness Mode (`relax_mode`)
**Icon:** `mdi:spa`  
**Purpose:** Calming, peaceful atmosphere

**Activated Scenes:**
- Bedroom: Relax (dim, warm)
- Living Room: Relax (dim, warm)
- Bathroom: Night (dim, warm)

**Use Cases:**
- Meditation
- Reading
- Unwinding after work
- Spa-like atmosphere

---

### 12. Emergency/Evacuation Mode (`emergency_mode`)
**Icon:** `mdi:alert-circle`  
**Purpose:** Maximum visibility for emergencies

**Activated Scenes:**
- All rooms: Maximum brightness

**Use Cases:**
- Emergency situations
- Quick evacuation
- Finding items urgently
- Security alerts

**Note:** In a real emergency implementation, this should also:
- Unlock doors
- Disable alarms
- Provide audio alerts
- Send notifications

---

### 13. Party Mode (`party_mode`)
**Icon:** `mdi:party-popper`  
**Purpose:** Festive, energetic atmosphere

**Activated Scenes:**
- Living Room: Party (bright, warm)
- Kitchen: Party (bright, warm)

**Use Cases:**
- House parties
- Celebrations
- Social events
- Holiday gatherings

**Enhancement Ideas:**
- Add color-changing light effects
- Integrate with music playlists
- Dynamic lighting scenes

---

### 14. Eco Mode (`eco_mode`)
**Icon:** `mdi:leaf`  
**Purpose:** Maximum energy conservation

**Activated Scenes:**
- All rooms: Off

**Use Cases:**
- Energy-saving periods
- Sleeping but want explicit eco mode
- Budget-conscious operation

**Enhancement Ideas:**
- Reduce HVAC temperature/cooling
- Disable non-essential devices
- Track energy savings

---

## Room-Specific Scenes

### Living Room
**File:** `/configuration/scenes/living_room.yaml`

**Lights:**
- Couch Light
- Dining Table Light
- Bookcase Spots
- Transition Spots

**Available Scenes:**
- `living_room_off` - All lights off
- `living_room_day` - Bright, neutral (4000K)
- `living_room_movie` - Dim ambient for movie watching
- `living_room_party` - Festive, warm lighting
- `living_room_relax` - Dim, warm, peaceful
- `living_room_romantic_dinner` - Intimate dining atmosphere

---

### Kitchen
**File:** `/configuration/scenes/kitchen.yaml`

**Lights:**
- Ceiling Light
- Spots

**Available Scenes:**
- `kitchen_off` - All lights off
- `kitchen_day` - Bright, neutral (4000K)
- `kitchen_morning` - Bright, cool (5000K) for energizing
- `kitchen_cleaning` - Maximum brightness (5000K)
- `kitchen_party` - Warm, festive lighting

---

### Bedroom
**File:** `/configuration/scenes/bedroom.yaml`

**Lights:**
- Fan Light

**Available Scenes:**
- `bedroom_off` - All lights off
- `bedroom_morning` - Bright, cool (4500K)
- `bedroom_night` - Very dim, warm (2000K)
- `bedroom_relax` - Moderate, warm (2500K)

---

### Bathroom
**File:** `/configuration/scenes/bathroom.yaml`

**Lights:**
- Bathroom Light

**Available Scenes:**
- `bathroom_off` - Light off
- `bathroom_day` - Bright, neutral (4000K)
- `bathroom_night` - Dim, warm (2200K)
- `bathroom_energize` - Bright, cool (5000K)

**Note:** The bathroom has a motion sensor automation that automatically turns lights on during the day (08:00-22:00).

---

### Shower
**File:** `/configuration/scenes/shower.yaml`

**Lights:**
- Shower Light

**Available Scenes:**
- `shower_off` - Light off
- `shower_morning` - Bright, cool (5000K)

---

### Office
**File:** `/configuration/scenes/office.yaml`

**Lights:**
- Desk Light
- Ceiling Light

**Available Scenes:**
- `office_off` - All lights off
- `office_work` - Bright, focused lighting (5000K)
- `office_relax` - Moderate, warm lighting (3000K)

---

### Mechanical Room
**File:** `/configuration/scenes/mechanical_room.yaml`

**Lights:**
- Mechanical Room Light

**Available Scenes:**
- `mechanical_room_off` - Light off
- `mechanical_room_cleaning` - Bright, cool (5000K)

**Note:** The mechanical room has an automation that turns the light on when the door opens and off when it closes.

---

## Usage Guide

### Activating House Modes

**Via Home Assistant UI:**
1. Navigate to Developer Tools → Services
2. Select service: `script.turn_on`
3. Choose the desired script (e.g., `script.movie_night`)
4. Click "Call Service"

**Via Voice Assistant (if configured):**
- "Hey Google, activate Movie Night"
- "Hey Google, turn on Sleep mode"

**Via Automation:**
```yaml
automation:
  - alias: "Auto sleep mode at 11 PM"
    trigger:
      - platform: time
        at: "23:00:00"
    action:
      - service: script.turn_on
        target:
          entity_id: script.home_sleep
```

### Activating Individual Room Scenes

**Via Home Assistant UI:**
1. Navigate to Developer Tools → Services
2. Select service: `scene.turn_on`
3. Choose the desired scene (e.g., `scene.living_room_movie`)
4. Click "Call Service"

**Via Automation:**
```yaml
automation:
  - alias: "Living room evening"
    trigger:
      - platform: sun
        event: sunset
    action:
      - service: scene.turn_on
        target:
          entity_id: scene.living_room_relax
```

---

## Future Improvements

### High Priority
1. **Add Conditional Logic to Modes**
   - Don't turn on bedroom lights if sleep sensor indicates sleeping
   - Skip bathroom if occupied sensor is active
   - Time-aware defaults (morning mode auto-adjusts based on sunrise)

2. **Integrate HVAC Control**
   - Adjust temperature/heating for each mode
   - Sleep mode: lower temperature
   - Away/Vacation: minimal climate control
   - Eco mode: optimize for energy efficiency

3. **Add Music/Audio Integration**
   - Party mode: upbeat playlist
   - Relax mode: calm music
   - Work mode: focus music or silence
   - Morning mode: energizing playlist

4. **Blinds/Shades Control**
   - Morning mode: open blinds
   - Sleep mode: close blinds
   - Movie night: close living room blinds
   - Away/Vacation: random blind movements

### Medium Priority
5. **Smart Presence Detection**
   - Automatically activate "Away" when all phones leave home zone
   - Auto-activate "Home" when first person arrives
   - Guest mode auto-detection based on unknown devices

6. **Enhanced Emergency Mode**
   - Unlock smart locks
   - Open garage door
   - Send notifications to all household members
   - Activate security cameras recording
   - Flash lights to indicate emergency path

7. **Scene Transitions**
   - Gradual transitions between scenes (fade in/out)
   - Configurable transition times
   - Smooth kelvin/brightness changes

8. **Adaptive Scenes**
   - Auto-adjust based on time of day
   - Learn preferences over time
   - Adjust based on occupancy patterns

### Low Priority
9. **Extended Party Mode Features**
   - Color-changing light effects
   - Sync lights with music beat
   - Holiday-themed color schemes

10. **Energy Monitoring**
    - Track energy usage per mode
    - Report on eco mode savings
    - Suggest optimal modes for energy efficiency

11. **Scene Favorites**
    - Quick access to most-used scenes
    - Per-user scene preferences
    - Dashboard widgets for common modes

12. **Seasonal Adjustments**
    - Winter: warmer color temperatures
    - Summer: cooler color temperatures
    - Holiday-specific modes (Halloween, Christmas, etc.)

---

## Room-Specific Automation Summary

### Existing Automations

**Bathroom:**
- Motion-activated lighting (08:00-22:00)
- 6-minute timeout after no motion
- File: `/configuration/automations/bathroom/automation-bathroom-motion.yaml`

**Mechanical Room:**
- Door-activated lighting
- Light on when door opens, off when door closes
- File: `/configuration/automations/mechanical_room/automation-mechanical-room-door-light.yaml`

### Recommended Additional Automations

**Living Room:**
- Sunset-activated ambient lighting
- TV-watching detection (dim lights automatically)
- Occupancy-based timeout

**Kitchen:**
- Motion-activated morning lights
- Cooking detection (brightness boost)
- Nighttime pathway lighting

**Bedroom:**
- Gradual wake-up lighting (sunrise simulation)
- Bedtime reminder (dim lights)
- Sleep detection (auto-off)

**Office:**
- Work hours activation
- Focus session timer
- Break time lighting changes

---

## Light Entity Reference

### Living Room
- `light.living_room_couch_light`
- `light.living_room_dining_table_light`
- `light.living_room_bookcase_spots`
- `light.living_room_transition_spots`

### Kitchen
- `light.kitchen_ceiling_light` (also referenced as `light.kitchen_ceiling`)
- `light.kitchen_spots`

### Bedroom
- `light.bedroom_fan_light`

### Bathroom
- `light.bathroom_light` (area-based)

### Shower
- `light.shower_light` (assumed entity)

### Office
- `light.office_desk_light` (assumed entity)
- `light.office_ceiling_light` (assumed entity)

### Mechanical Room
- `light.mechanical_room_light`

**Note:** Some entities (shower, office) are assumed based on typical home setup. Verify these entities exist in your Home Assistant instance before using the corresponding scenes.

---

## Color Temperature Guide

Understanding kelvin values used in scenes:

- **2000K-2200K:** Very warm, candlelight-like (Night scenes)
- **2500K-2700K:** Warm, cozy (Relax scenes, evening)
- **3000K:** Soft white (Party, comfortable)
- **4000K:** Neutral white (Day scenes, general use)
- **4500K-5000K:** Cool white, energizing (Morning, cleaning, work)

---

## Contributing

When adding new scenes or modes:

1. Follow the existing naming convention: `{room}_{scene_name}`
2. Use appropriate icons from Material Design Icons
3. Include descriptive aliases and comments
4. Document new additions in this file
5. Test thoroughly before committing
6. Consider energy efficiency in scene design

---

**Last Updated:** January 2, 2026  
**Maintained By:** Home Automation Team  
**Repository:** broersma-forslund/homelab
