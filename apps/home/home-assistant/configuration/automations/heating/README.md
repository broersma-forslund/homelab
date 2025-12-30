# TRVZB Temperature Sensor Fallback Monitoring

## Overview

This automation monitors all TRVZB (Thermostatic Radiator Valve with Zigbee) devices in the Home Assistant instance and sends notifications to administrators when a TRV switches from external temperature sensor mode to internal sensor mode.

## Problem Statement

When a TRVZB is configured to use an external temperature sensor, it will automatically switch to fallback modes (`external_2` or `external_3`) if the external sensor stops sending updates for several hours. These fallback modes use the TRV's internal temperature sensor instead, which can result in:

- Inaccurate temperature readings (TRV mounted on radiator reads higher temps)
- Poor heating control
- Increased energy consumption
- Reduced comfort

## Solution

The automation in `automation-trvzb-temperature-sensor-fallback.yaml` automatically detects when any TRVZB switches to fallback mode and sends a persistent notification to administrators.

## How It Works

1. **Event Monitoring**: Listens to all `state_changed` events in Home Assistant
2. **Entity Filtering**: Identifies entities matching the pattern `*.temperature_sensor_select`
3. **State Change Detection**: Detects transitions from `external` to `external_2` or `external_3`
4. **Notification**: Creates a persistent notification with troubleshooting information

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

## Configuration

The automation requires no manual configuration. It automatically discovers and monitors all TRVZBs in your Home Assistant instance.

### Supported Entities

Any select entity ending with `_temperature_sensor_select` will be monitored, such as:
- `select.bedroom_radiator_temperature_sensor_select`
- `select.living_room_radiator_temperature_sensor_select`
- `select.office_radiator_temperature_sensor_select`

### Automation Mode

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

Uses the `event` platform with `state_changed` event type for real-time monitoring of all entities without requiring explicit entity_id lists.

### Conditions

Two template conditions ensure accuracy:
1. Entity ID must end with `_temperature_sensor_select`
2. State must transition from `external` to `external_2` or `external_3`

### Action

Creates a persistent notification using `persistent_notification.create` service with a unique notification_id per entity.

## Maintenance

The automation requires no maintenance and will automatically work with newly added TRVZBs. No updates needed when adding or removing devices.

## Compatibility

- **Home Assistant**: 2021.12 or later (requires event trigger support)
- **TRVZB Devices**: Any Zigbee TRV that supports external temperature sensor mode
- **Integration**: Works with Zigbee2MQTT, ZHA, or any integration that exposes `select.*_temperature_sensor_select` entities
