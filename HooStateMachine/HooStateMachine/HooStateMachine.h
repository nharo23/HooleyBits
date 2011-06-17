//
//  HooStateMachine.h
//  SHShared2
//
//  Created by Steven Hooley on 21/05/2011.
//  Copyright 2011 Tinsal Parks. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HooStateMachine_state;

@interface HooStateMachine : _ROOT_OBJECT_ {
@private
    
    HooStateMachine_state *_startState;
    NSMutableArray *_resetEvents;
    NSArray *_transitions;
}

- (id)initWithStartState:(HooStateMachine_state *)startState transitions:(NSArray *)transitions resetEvents:(NSMutableArray *)resetEvents;

- (BOOL)isResetEvent:(NSString *)eventName;
- (HooStateMachine_state *)startState;
- (void)addResetEvents:(NSArray *)events;

@end