//
//  AppDelegate.h
//  FieldListener
//
//  Created by gewara on 12-6-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSTextField *_textFieldURLString;
    IBOutlet NSTextView *_textViewLog;
    NSString *_currentURLString;
}

@property (assign) IBOutlet NSWindow *window;

@end
