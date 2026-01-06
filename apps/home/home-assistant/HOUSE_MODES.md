# House Modes & Scenes Documentation

This document describes all the house modes (scripts) and room scenes available in the Home Assistant configuration.

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

### 3. Sleep/Night Mode (`sleep_mode`)
**Icon:** `mdi:power-sleep`  
**Purpose:** Prepare the house for sleep
**Voice Command:** "Activate Sleep" or "Turn on Sleep mode"

**Activated Scenes:**
- Living Room: Off
- Kitchen: Off
- Bedroom: Night (off)
- Bathroom: Night (very dim, warm - for night-time visits)

**Use Cases:**
- Bedtime routine
- Night-time bathroom visits with minimal wake-up effect
- Minimal light pollution for sleep

---

### 4. Morning Mode (`morning_mode`)
**Icon:** `mdi:weather-sunset-up`  
**Purpose:** Energizing morning routine
**Voice Command:** "Activate Morning Mode"

**Activated Scenes:**
- Bedroom: Morning (bright, cool)
- Bathroom: Day (bright)
- Kitchen: Morning (bright, cool)

**Use Cases:**
- Wake-up routine
- Morning preparation
- Energizing start to the day

---

### 5. Guests Mode (`guests_mode`)
**Icon:** `mdi:account-multiple`  
**Purpose:** Welcoming atmosphere for visitors
**Voice Command:** "Activate Guests Mode"

**Activated Scenes:**
- Living Room: Day
- Kitchen: Day
- Bathroom: Day

**Use Cases:**
- Having guests over
- Dinner parties
- Social gatherings

---

### 6. Movie Night (`movie_night`)
**Icon:** `mdi:movie`  
**Purpose:** Cinema-like atmosphere for watching movies
**Voice Command:** "Activate Movie Night"

**Activated Scenes:**
- Living Room: Movie (dim ambient, warm)
- Kitchen: Movie (dim spots only)

**Use Cases:**
- Watching movies or TV shows
- Gaming sessions
- Minimal screen glare

---

### 7. Romantic Dinner (`romantic_dinner`)
**Icon:** `mdi:candelabra-fire`  
**Purpose:** Intimate dining atmosphere
**Voice Command:** "Activate Romantic Dinner"

**Activated Scenes:**
- Living Room: Romantic Dinner (dining area focused)
- Kitchen: Romantic Dinner (dim spots only)

**Use Cases:**
- Date nights at home
- Special occasions
- Intimate meals

---

### 8. Cleaning Mode (`cleaning_mode`)
**Icon:** `mdi:spray-bottle`  
**Purpose:** Bright, clear lighting for cleaning tasks
**Voice Command:** "Activate Cleaning Mode"

**Activated Scenes:**
- Living Room: Day (bright)
- Kitchen: Cleaning (bright, cool)

**Use Cases:**
- House cleaning
- Detailed work that requires visibility
- Maintenance tasks

---

### 9. Work Mode (`work_mode`)
**Icon:** `mdi:briefcase`  
**Purpose:** Focused work environment

**Activated Scenes:**
- Living Room: Off
- Kitchen: Off

**Use Cases:**
- Remote work from home
- Focused tasks requiring concentration
- Minimizing distractions

**Note:** When office gets smart lights, this will activate `scene.office_work` for optimal focus lighting.

---

### 10. Relax/Wellness Mode (`relax_mode`)
**Icon:** `mdi:spa`  
**Purpose:** Calming, peaceful atmosphere
**Voice Command:** "Activate Relax Mode"

**Activated Scenes:**
- Bedroom: Relax (dim, warm)
- Living Room: Relax (dim, warm)
- Bathroom: Night (very dim, warm)

**Use Cases:**
- Meditation
- Reading
- Unwinding after work
- Spa-like atmosphere

---

### 11. Party Mode (`party_mode`)
**Icon:** `mdi:party-popper`  
**Purpose:** Festive, energetic atmosphere
**Voice Command:** "Activate Party Mode"

**Activated Scenes:**
- Living Room: Party (bright, warm)
- Kitchen: Party (bright, warm)

**Use Cases:**
- House parties
- Celebrations
- Social events
- Holiday gatherings

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
- `living_room_movie` - Dim ambient for movie watching (voice-activated)
- `living_room_party` - Festive, warm lighting (voice-activated)
- `living_room_relax` - Dim, warm, peaceful (voice-activated)
- `living_room_romantic_dinner` - Intimate dining atmosphere (voice-activated)

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
- `kitchen_party` - Warm, festive lighting (voice-activated)
- `kitchen_movie` - Dim spots only for movie ambiance (voice-activated)
- `kitchen_romantic_dinner` - Dim spots for intimate dining (voice-activated)

**Note:** Kitchen is part of the living room space, so lighting bleeds between areas. Kitchen scenes coordinate with living room for movie night and romantic dinner modes.

---

### Bedroom
**File:** `/configuration/scenes/bedroom.yaml`

**Lights:**
- Fan Light

**Available Scenes:**
- `bedroom_off` - Light off
- `bedroom_morning` - Bright, cool (4500K)
- `bedroom_night` - Light off (for sleeping)
- `bedroom_relax` - Moderate, warm (2500K)

---

### Bathroom
**File:** `/configuration/scenes/bathroom.yaml`

**Lights:**
- Bathroom Light

**Available Scenes:**
- `bathroom_off` - Light off
- `bathroom_day` - Bright, neutral (4000K)
- `bathroom_night` - Very dim, warm (2000K) - designed to not trigger wake-up response

**Note:** The bathroom has a motion sensor automation that:
- Automatically turns lights on when motion detected
- Uses `bathroom_night` scene between 22:00-08:00 (very dim, warm)
- Uses `bathroom_day` scene during 08:00-22:00
- Turns off after 6 minutes of no motion

---

### Shower (Future Expansion)
**File:** `/configuration/scenes/shower.yaml`

**Status:** Scenes commented out - waiting for smart lights installation

**Planned Scenes:**
- `shower_off` - Light off
- `shower_morning` - Bright, cool (5000K) for energizing

**Note:** Shower area has sinks and mirror, so energizing bright lighting makes sense for morning routines. Once smart lights are installed, uncomment the scenes.

---

### Office (Future Expansion)
**File:** `/configuration/scenes/office.yaml`

**Status:** Scenes commented out - waiting for smart lights installation

**Planned Scenes:**
- `office_off` - All lights off
- `office_work` - Bright, focused lighting (5000K) for productivity
- `office_relax` - Moderate, warm lighting (3000K)

**Note:** Once office gets smart lights, uncomment scenes and enable in `work_mode` script.

---

## Voice Control with Google Assistant

The following scripts are exposed to Google Assistant for voice control. Scripts orchestrate multiple rooms together, making them ideal for voice commands like "Activate Movie Night" which sets the entire house to the appropriate mode.

### Voice-Activated House Mode Scripts
- `script.movie_night` - "Activate Movie Night"
- `script.romantic_dinner` - "Activate Romantic Dinner"
- `script.party_mode` - "Activate Party Mode"
- `script.relax_mode` - "Activate Relax Mode"
- `script.cleaning_mode` - "Activate Cleaning Mode"
- `script.morning_mode` - "Activate Morning Mode"
- `script.home_sleep` - "Activate Sleep" / "Turn on Sleep mode"
- `script.guests_mode` - "Activate Guests Mode"

**Why Scripts, Not Scenes?**  
Scripts are exposed to Google Assistant because they control multiple rooms in coordination. Individual room scenes (like `scene.living_room_movie`) are for internal use by scripts and automations, not direct voice control. This way, you say "Activate Movie Night" once and the whole house adjusts appropriately.

**Configuration:** See `/configuration/integrations/google_home.yaml`

---

## Usage Guide

### Activating House Modes

**Via Home Assistant UI:**
1. Navigate to Developer Tools → Services
2. Select service: `script.turn_on`
3. Choose the desired script (e.g., `script.movie_night`)
4. Click "Call Service"

**Via Voice Assistant:**
- "Hey Google, activate Movie Night"
- "Hey Google, turn on Sleep mode"
- "Hey Google, activate Romantic Dinner"

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

**Via Voice Assistant:**
- "Hey Google, turn on Living Room Movie"
- "Hey Google, turn on Kitchen Party"

---

## Future Improvements

### High Priority
1. **Complete Smart Light Installation**
   - Install smart lights in office for work mode functionality
   - Install smart lights in shower for morning energize routine
   - Uncomment and enable related scenes once installed

2. **Integrate HVAC Control**
   - Adjust temperature/heating for each mode using schedules (not scenes)
   - Sleep mode: lower temperature
   - Away mode: minimal climate control
   - Use Home Assistant's climate schedules for optimal control

3. **Add Music/Audio Integration**
   - Party mode: upbeat playlist
   - Relax mode: calm music
   - Work mode: focus music or silence
   - Morning mode: energizing playlist

4. **Blinds/Shades Control**
   - Morning mode: open blinds
   - Sleep mode: close blinds
   - Movie night: close living room blinds

### Medium Priority
5. **Smart Presence Detection**
   - Automatically activate "Away" when all phones leave home zone
   - Auto-activate "Home" when first person arrives

6. **Scene Transitions**
   - Gradual transitions between scenes (fade in/out)
   - Configurable transition times
   - Smooth kelvin/brightness changes

7. **Adaptive Scenes**
   - Auto-adjust based on time of day
   - Learn preferences over time
   - Adjust based on occupancy patterns

### Low Priority
8. **Extended Party Mode Features**
   - Color-changing light effects
   - Sync lights with music beat
   - Holiday-themed color schemes

9. **Energy Monitoring**
   - Track energy usage per mode
   - Report on potential savings
   - Suggest optimal modes for energy efficiency

10. **Scene Favorites**
    - Quick access to most-used scenes
    - Per-user scene preferences
    - Dashboard widgets for common modes

---

## Automation Summary

### Existing Automations

**Bathroom:**
- Motion-activated lighting (24/7 operation)
- Uses `bathroom_night` scene between 22:00-08:00 (very dim warm light)
- Uses `bathroom_day` scene between 08:00-22:00 (bright neutral light)
- 6-minute timeout after no motion
- File: `/configuration/automations/bathroom/automation-bathroom-motion.yaml`

**Mechanical Room:**
- Door-activated lighting (simple on/off, no scenes needed)
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

**Bedroom:**
- Gradual wake-up lighting (sunrise simulation)
- Bedtime reminder (dim lights)

---

## Color Temperature Guide

Understanding kelvin values used in scenes:

- **2000K:** Very warm, minimal wake-up effect (Bathroom night)
- **2200K:** Warm, candlelight-like (Movie, romantic scenes)
- **2500K-2700K:** Warm, cozy (Relax scenes, evening)
- **3000K:** Soft white (Party, comfortable)
- **4000K:** Neutral white (Day scenes, general use)
- **4500K-5000K:** Cool white, energizing (Morning, cleaning, work)

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

### Shower (Future)
- `light.shower_light` (commented out, pending installation)

### Office (Future)
- `light.office_desk_light` (commented out, pending installation)
- `light.office_ceiling_light` (commented out, pending installation)

### Mechanical Room
- `light.mechanical_room_light` (automation-controlled, no scenes)

---

## Design Decisions

### Why No Mechanical Room Scenes?
The mechanical room only needs simple on/off functionality via door automation. Scenes are overkill for a utility space with basic lighting needs.

### Why Remove Vacation, Emergency, and Eco Modes?
- **Vacation Mode:** Identical to Away Mode in functionality
- **Emergency Mode:** Unclear use case for home automation
- **Eco Mode:** Just turns off lights - use Away Mode instead

### Why Bedroom Night Turns Off Light?
People don't sleep with lights on, even dimmed. For better sleep hygiene, the bedroom light is completely off during sleep mode.

### Why Lower Bathroom Night Temperature to 2000K?
Research shows that warmer, dimmer light (2000K, 20 brightness) minimizes disruption to circadian rhythm during night-time bathroom visits, helping maintain sleepiness.

---

## Contributing

When adding new scenes or modes:

1. Follow the existing naming convention: `{room}_{scene_name}`
2. Use appropriate icons from Material Design Icons
3. Include descriptive aliases and comments
4. Document new additions in this file
5. Test thoroughly before committing
6. Consider energy efficiency in scene design
7. Expose voice-activated scripts/scenes to Google Assistant

---

**Last Updated:** January 6, 2026  
**Maintained By:** Home Automation Team  
**Repository:** broersma-forslund/homelab
