# TRVZB Temperature Sensor Fallback Monitoring

## Overview

This automation monitors TRVZB (Thermostatic Radiator Valve with Zigbee) devices in the Home Assistant instance and sends notifications to administrators when a TRV switches from external temperature sensor mode to internal sensor mode.

## Problem Statement

When a TRVZB is configured to use an external temperature sensor, it will automatically switch to fallback modes (`external_2` or `external_3`) if the external sensor stops sending updates for several hours. These fallback modes use the TRV's internal temperature sensor instead, which can result in:

- Inaccurate temperature readings (TRV mounted on radiator reads higher temps)
- Poor heating control
- Increased energy consumption
- Reduced comfort

## Solution

The automation in `automation-trvzb-temperature-sensor-fallback.yaml` detects when any configured TRVZB switches to fallback mode and sends a persistent notification to administrators.

## Configuration Required

**Important**: For optimal performance, you must explicitly list the entity IDs of your TRVZB temperature sensor select entities in the automation file.

### Finding Your TRVZB Entities

1. Go to **Developer Tools > States** in Home Assistant
2. Search for entities ending with `_temperature_sensor_select`
3. Note down the entity IDs (e.g., `select.bedroom_radiator_temperature_sensor_select`)

### Adding Entities to the Automation

Edit the automation file and add your entity IDs under the `entity_id:` section:

```yaml
trigger:
  - platform: state
    entity_id:
      - select.bedroom_radiator_temperature_sensor_select
      - select.living_room_radiator_temperature_sensor_select
      - select.office_radiator_temperature_sensor_select
    to:
      - 'external_2'
      - 'external_3'
    from: 'external'
```

## Performance Considerations

This automation uses a **state trigger** which is the most performant approach:
- ✅ Only evaluates when the listed entities change state
- ✅ Does not fire on every state change in Home Assistant
- ✅ Minimal CPU and memory overhead
- ✅ Suitable for systems with hundreds of entities

**Alternative Approaches Considered:**
- **Event trigger** (`state_changed` event): Would fire on every state change (100s per second), very inefficient
- **Template trigger**: Would evaluate on select entity changes, but less reliable for detecting specific state transitions

The trade-off is that you must maintain the entity list when adding new TRVZBs to your system.

## How It Works

1. **State Monitoring**: Watches the specified entities for state changes
2. **Transition Detection**: Triggers when state changes from `external` to `external_2` or `external_3`
3. **Notification**: Creates a persistent notification with troubleshooting information

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

## Supported Entities

Any select entity ending with `_temperature_sensor_select` can be monitored, such as:
- `select.bedroom_radiator_temperature_sensor_select`
- `select.living_room_radiator_temperature_sensor_select`
- `select.office_radiator_temperature_sensor_select`

## Automation Mode

- **Mode**: `queued`
- **Max**: 10 simultaneous triggers

This allows the automation to handle multiple TRVZBs entering fallback mode simultaneously without missing any alerts.

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
   - The notification will persist until dismissed
   - Multiple TRVs will generate separate notifications

## Technical Details

### Trigger Platform

Uses the `state` platform for optimal performance:
- Only triggers when specified entities change state
- Does not evaluate on every state change in Home Assistant
- Reliable state transition detection with `from` and `to` parameters

### Action

Creates a persistent notification using `persistent_notification.create` service with a unique notification_id per entity.

### Why Not Auto-Discovery?

While auto-discovery would be convenient, it would require either:
1. **Event trigger**: Fires on every state change (100s/sec), extremely inefficient
2. **Template trigger**: Less reliable for state transitions, still evaluates frequently

The explicit entity list approach provides:
- ✅ Best performance (only evaluates specified entities)
- ✅ Reliable state transition detection
- ✅ Predictable behavior
- ✅ Easy debugging (you know exactly what's being monitored)

## Maintenance

When adding new TRVZBs to your system:
1. Identify the new temperature sensor select entity
2. Add it to the `entity_id:` list in the automation
3. Reload automations in Home Assistant (Developer Tools > YAML > Automations)

## Compatibility

- **Home Assistant**: 2021.4 or later (requires state trigger support)
- **TRVZB Devices**: Any Zigbee TRV that supports external temperature sensor mode
- **Integration**: Works with Zigbee2MQTT, ZHA, or any integration that exposes `select.*_temperature_sensor_select` entities
