//
//  ResultLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "ResultLayer.h"

@implementation ResultLayer

- (id)initWithScore:(int)score {
  self = [super init];
  if (self) {
    CCSprite* bg = [CCSprite spriteWithFile:@"result.png"];
    bg.position = ccp(240, 180);
    [self addChild:bg];
    CCSprite* frame = [CCSprite spriteWithFile:@"result_frame.png"];
    frame.position = ccp(240, 160);
    [self addChild:frame];
  }
  return self;
}

@end
