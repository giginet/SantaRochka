//
//  MainLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"

@implementation MainLayer

- (id)init {
  self = [super init];
  if (self) {
    CCLayer* bgLayer = [[CCLayer alloc] init];
    KWScrollLayer* background = [KWScrollLayer layerWithFile:@"background.png"];
    background.velocity = [KWVector vectorWithPoint:CGPointMake(-1, 0)];
    [bgLayer addChild:background];
    
    [self addChild:bgLayer];
    id ready = [ReadyState state];
    stateManager_ = [[KWStateManager alloc] initWithInitialState:ready];
    
    [self addChild:stateManager_.runningState];
    
    CCSprite* frame = [CCSprite spriteWithFile:@"main_frame.png"];
    frame.position = CGPointMake(240, 165);
    
    [self addChild:frame];
  }
  return self;
}

- (void)draw {
  [super draw];
  [stateManager_.runningState draw];
}

@end

@implementation ReadyState

- (id)init {
  self = [super init];
  if (self) {
    CCSprite* ready = [CCSprite spriteWithFile:@"ready.png"];
    ready.position = CGPointMake(190, 250);
    [self addChild:ready];
    
    CCSprite* stage = [CCSprite spriteWithFile:@"stage1.png"];
    stage.position = CGPointMake(90, 120);
    [self addChild:stage];
    NSLog(@"init");
  }
  return self;
}

- (void)draw {
  [super draw];
}

@end