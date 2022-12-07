//
//  main.swift
//  supercs
//
//  Created by realityone on 2022/12/8.
//

import Foundation
import Cocoa
import Carbon.HIToolbox

// Create a new event tap to monitor all events
let eventTap = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: .defaultTap,
    eventsOfInterest: CGEventMask(1 << CGEventType.keyDown.rawValue),
    callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
        // Check if the event is a key down event
        let userData = event.getIntegerValueField(CGEventField.eventSourceUserData)
        if type == CGEventType.keyDown && userData == 0 {
            // Get the event as a NSEvent
            let nsEvent = NSEvent(cgEvent: event)!
            // Check if the command and S keys are pressed
            if (nsEvent.modifierFlags.contains(.command) && nsEvent.keyCode == kVK_ANSI_S) ||
                (nsEvent.modifierFlags.contains(.command) && nsEvent.keyCode == kVK_ANSI_C){
                // Command+S/Command+C was pressed, so perform some action here
                repeatEvent(event:event, times:5)
            }
        }
        // Return the event so it can continue to be processed
        return Unmanaged.passRetained(event)
    },
    userInfo: nil
)

// Enable the event tap
if let eventTap = eventTap {
    let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
    CGEvent.tapEnable(tap: eventTap, enable: true)
    CFRunLoopRun()
}

func repeatEvent(event: CGEvent, times: Int)  {
    let pid = event.getIntegerValueField(CGEventField.eventTargetUnixProcessID)
    for i in 1...times {
        DispatchQueue.global(qos: .userInteractive).async {
            event.setIntegerValueField(CGEventField.eventSourceUserData, value: Int64(i))
            event.postToPid(pid_t(pid))
            print("Repeating", i)
        }
    }
}
