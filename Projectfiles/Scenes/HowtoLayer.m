//
//  HowtoLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/25.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "MainLayer.h"
#import "HowtoLayer.h"

@implementation HowtoLayer

- (id)init {
  self = [super init];
  if (self) {
    CCLayer* bgLayer = [[CCLayer alloc] init];
    KWScrollLayer* background = [KWScrollLayer layerWithFile:@"background.png"];
    background.velocity = [KWVector vectorWithPoint:CGPointMake(1.5, 0)];
    [bgLayer addChild:background];
    
    [self addChild:bgLayer];
    
    
    CCDirector* director = [CCDirector sharedDirector];
    guide_ = [CCSprite spriteWithFile:@"guide0.png"];
    guide_.position = director.screenCenter;
    [self addChild:guide_];
    
    CCSprite* frame = [CCSprite spriteWithFile:@"main_frame.png"];
    frame.position = CGPointMake(240, 165);
    [self addChild:frame];
    
    phase_ = 0;
    self.isTouchEnabled = YES;
  }
  return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if (phase_ == 0) {
    [guide_ setTexture:[[CCTextureCache sharedTextureCache] addImage:@"guide1.png"]];
  } else if(phase_ == 1){
    [[CCDirector sharedDirector] pushScene:[MainLayer nodeWithScene]];
  }
  ++phase_;
  return YES;
}



@end
