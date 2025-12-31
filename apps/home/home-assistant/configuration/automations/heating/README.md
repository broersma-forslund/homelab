# TRVZB Temperature Sensor Fallback Monitoring

## Overview

This automation monitors TRVZB (Thermostatic Radiator Valve with Zigbee) devices in the Home Assistant instance and sends notifications to administrators when a TRV is in fallback mode (using internal temperature sensor instead of external sensor).

## Problem Statement

When a TRVZB is configured to use an external temperature sensor, it will automatically switch to fallback modes (`external_2` or `external_3`) if the external sensor stops sending updates for 2 hours. These fallback modes use the TRV's internal temperature sensor instead, which can result in:

- Inaccurate temperature readings (TRV mounted on radiator reads higher temps)
- Poor heating control
- Increased energy consumption
- Reduced comfort

## Solution

The automation in `automation-trvzb-temperature-sensor-fallback.yaml` checks all TRVZBs every 3 hours and sends a persistent notification for any device in fallback mode.

## Configuration Required

**None!** The automation automatically discovers all TRVZB temperature sensor select entities (those ending with `_temperature_sensor_select`).

## How It Works

1. **Time-based Check**: Runs every 3 hours (TRVZB switches to fallback after 2 hours of no updates)
2. **Auto-discovery**: Finds all `select.*_temperature_sensor_select` entities
3. **Status Check**: Identifies entities in `external_2` or `external_3` state
4. **Notification**: Creates a persistent notification for each device in fallback mode

## Performance Considerations

This automation uses a **time-based trigger** which is highly efficient:
- ✅ Runs only every 3 hours (8 times per day)
- ✅ Minimal CPU and memory overhead
- ✅ Auto-discovers all TRVZBs without configuration
- ✅ Notification delay is acceptable (worst case: 3 hours after fallback occurs)

**Why This Approach:**
- TRVZB devices switch to fallback mode after 2 hours without external sensor updates
- Checking every 3 hours ensures detection within a reasonable timeframe
- The impact of delayed notification is minimal (slightly cooler temperature)
- This approach provides the best balance of functionality and performance

**Alternative Approaches Considered:**
- **Event trigger** (`state_changed` event): Fires on every state change (100s/sec), extremely inefficient ❌
- **State trigger**: Requires manual entity configuration, more immediate but more maintenance ⚠️
- **Time-based trigger** (current): Best performance, zero configuration, acceptable delay ✅

## Notification Details

When triggered, the notification includes:

- **Title**: "TRVZB Temperature Sensor Fallback Detected"
- **Friendly Name**: The human-readable name of the affected TRV
- **Current State**: The fallback mode (`external_2` or `external_3`)
- **Previous State**: Confirms it was in `external` mode
- **Troubleshooting Checklist**:
  - Check battery level of external sensor
  - Verify connectivity of external sensor
  - Check pairing status between TRV and external sensor
- **Entity ID**: For easy identification in Home Assistant
- **Timestamp**: When the fallback was detected

## Notification Details

When a TRVZB is found in fallback mode, the notification includes:

- **Title**: "TRVZB Temperature Sensor Fallback Detected"
- **Friendly Name**: The human-readable name of the affected TRV
- **Current State**: The fallback mode (`external_2` or `external_3`)
- **Troubleshooting Checklist**:
  - Check battery level of external sensor
  - Verify connectivity of external sensor
  - Check pairing status between TRV and external sensor
- **Entity ID**: For easy identification in Home Assistant
- **Timestamp**: When the check was performed

## Supported Entities

Any select entity ending with `_temperature_sensor_select` is automatically monitored, such as:
- `select.bedroom_radiator_temperature_sensor_select`
- `select.living_room_radiator_temperature_sensor_select`
- `select.office_radiator_temperature_sensor_select`

## Automation Behavior

- **Mode**: `single` (prevents overlapping executions)
- **Schedule**: Every 3 hours (at 00:00, 03:00, 06:00, 09:00, 12:00, 15:00, 18:00, 21:00)
- **Notification Persistence**: Each TRV gets a unique notification that persists until dismissed or the issue is resolved

## Maintenance

**Zero maintenance required!** The automation automatically discovers new TRVZBs when they are added to Home Assistant. No configuration updates needed.

## Troubleshooting

If you receive a notification:

1. **Check External Sensor Battery**
   - Low battery is the most common cause
   - Replace battery and wait for sensor to reconnect

2. **Verify Sensor Connectivity**
   - Check if the external sensor is still paired
   - Verify the sensor is within Zigbee network range
   - Check for Zigbee network issues

3. **Re-pair if Necessary**
   - If sensor is unresponsive, re-pair it with the TRV
   - Set TRV back to `external` mode after pairing

4. **Monitor the Situation**
   - The notification will reappear on the next 3-hour check if still in fallback
   - Once resolved (TRV returns to `external` mode), the notification will stop appearing

## Technical Details

### Trigger Platform

Uses the `time_pattern` platform for scheduled checks:
- Runs every 3 hours (configured as `hours: '/3'`)
- Minimal performance impact (8 executions per day)
- No event processing overhead

### Action Logic

Uses a `repeat` loop with dynamic entity discovery:
1. Template finds all `select.*_temperature_sensor_select` entities
2. Filters to only those in `external_2` or `external_3` state
3. Creates a notification for each affected device
4. Unique notification IDs prevent duplicates

### Why Time-based Instead of State-based?

Time-based triggers offer the best balance:
- ✅ **Performance**: Only runs 8 times per day (vs. potentially 100s of times per second)
- ✅ **Zero Configuration**: Auto-discovers all devices without manual setup
- ✅ **Acceptable Delay**: 3-hour maximum delay is fine for this use case
- ✅ **Simplicity**: No entity lists to maintain

## Compatibility

- **Home Assistant**: 2021.4 or later (requires time_pattern trigger support)
- **TRVZB Devices**: Any Zigbee TRV that supports external temperature sensor mode
- **Integration**: Works with Zigbee2MQTT, ZHA, or any integration that exposes `select.*_temperature_sensor_select` entities
