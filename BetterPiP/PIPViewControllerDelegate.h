//
//  PIPViewControllerDelegate.h
//  PiPHack
//
//  Created by Stephen Radford on 09/09/2016.
//  Copyright © 2016 Cocoon Development Ltd. All rights reserved.
//

#ifndef PIPViewControllerDelegate_h
#define PIPViewControllerDelegate_h

@class PIPViewController;

@protocol PIPViewControllerDelegate <NSObject>
@optional
- (BOOL)pipShouldClose:(PIPViewController *)pip;
- (void)pipDidClose:(PIPViewController *)pip;
- (void)pipActionPlay:(PIPViewController *)pip;
- (void)pipActionPause:(PIPViewController *)pip;
- (void)pipActionStop:(PIPViewController *)pip;
@end

#endif /* PIPViewControllerDelegate_h */
