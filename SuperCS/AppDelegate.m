//
//  AppDelegate.m
//  SuperCS
//
//  Created by realityone on 15/10/11.
//  Copyright © 2015年 realityone. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setUpStatusButton {
    NSStatusBarButton *statusButton = self.statusItem.button;
    NSImage *buttonImage = [NSImage imageNamed:@"Status"];
    NSImage *alterButtonImage = [NSImage imageNamed:@"StatusHighlighted"];
    
    statusButton.image = buttonImage;
    statusButton.alternateImage = alterButtonImage;
}

static OSStatus superHotKeyHandler(EventHandlerCallRef nextHandler, EventRef event, void *userData) {
    NSLog(@"Event");
    
    return CallNextEventHandler(nextHandler, event);
}

- (void)registerHotKeys {
    EventHotKeyRef hotKeyRef;
    EventHotKeyID hotKeyID;
    EventTypeSpec eventType;
    EventHandlerUPP	handlerUPP;
    
    eventType.eventClass = kEventClassKeyboard;
    eventType.eventKind = kEventHotKeyPressed;
    
    handlerUPP = NewEventHandlerUPP(superHotKeyHandler);
    InstallApplicationEventHandler(handlerUPP, 1, &eventType, nil, nil);
    
    hotKeyID.signature = 'xxxx';
    hotKeyID.id = 1234;
    
    RegisterEventHotKey(kVK_ANSI_C, cmdKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
    RegisterEventHotKey(kVK_ANSI_S, cmdKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:24];
    [self setUpStatusButton];
    
    [self registerHotKeys];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
