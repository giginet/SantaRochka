//
//  MainLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWMusicManager.h"
#import "MainLayer.h"

@interface MainLayer()
- (void)onReady;
- (void)onGameStart;
- (void)onGameOver;
- (void)onCount;
- (void)onPresent;
@end

@implementation MainLayer

- (id)init {
  self = [super init];
  if (self) {
    for(NSString* bgm in [NSArray arrayWithObjects:@"se1.caf", @"se2.caf", @"se3.caf", nil]){
      [[KWMusicManager sharedManager] preloadEffect:bgm];
    }
    [[KWMusicManager sharedManager] preloadBg:@"afternoon_lesson.caf"];
    CCLayer* bgLayer = [[CCLayer alloc] init];
    KWScrollLayer* background = [KWScrollLayer layerWithFile:@"background.png"];
    background.velocity = [KWVector vectorWithPoint:CGPointMake(-1, 0)];
    [bgLayer addChild:background];
    
    [self addChild:bgLayer];
    
    CCSprite* frame = [CCSprite spriteWithFile:@"main_frame.png"];
    frame.position = CGPointMake(240, 165);
    
    
    CCSprite* rud = [KWAnimation spriteWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"rud.png"]
                                                   size:CGSizeMake(90, 70) 
                                                  delay:0.5];
    rochka_ = [KWAnimation spriteWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"rochka.png"] 
                                             size:CGSizeMake(112, 110) 
                                            delay:0];
    
    CCSprite* bag = [CCSprite spriteWithFile:@"bag.png"];
    rochka_.position = CGPointMake(390, 175);
    rud.position = CGPointMake(380, 140);
    bag.position = CGPointMake(405, 145);
    [self addChild:rud];
    [self addChild:rochka_];
    [self addChild:bag];
    [self onReady];
    [self addChild:frame];
    
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)onEnterTransitionDidFinish {
  [[KWMusicManager sharedManager] playBgWithLoop:YES];
}

- (void)onReady {
  CCSprite* ready = [CCSprite spriteWithFile:@"ready.png"];
  ready.position = CGPointMake(190, 250);
  ready.opacity = 0;
  CCSequence* seq = [CCSequence actions:[CCFadeIn actionWithDuration:0.25], 
                      [CCDelayTime actionWithDuration:2], 
                      [CCFadeOut actionWithDuration:0.25],
                      [CCCallFunc actionWithTarget:self selector:@selector(onGameStart)],
                      nil];

  [ready runAction:seq];
  [self addChild:ready];
  
  
  CCSprite* stage = [CCSprite spriteWithFile:@"stage1.png"];
  stage.position = CGPointMake(90, 120);
  stage.opacity = 0;
  [stage runAction:[CCFadeIn actionWithDuration:0.25]];
  [self addChild:stage];
}

- (void)onGameStart {
  KWTimer* timer = [KWTimer timerWithMax:3];
  timer.looping = YES;
  [timer setOnCompleteListener:self selector:@selector(onCount)];
  [timer play];
}

- (void)onGameOver {
  NSLog(@"gameOver");
}

- (void)onCount {
  [self removeChild:balloon_ cleanup:YES];
  KWRandom* rnd = [KWRandom random];
  int index = [rnd nextIntWithRange:NSMakeRange(0, 6)];
  isYes_ = index < 3;
  if (isYes_) {
    balloon_ = [CCSprite spriteWithFile:@"n_yes.png" 
                                   rect:CGRectMake(98 * index, 0, 98, 87)];
  } else {
    balloon_ = [CCSprite spriteWithFile:@"n_no.png" 
                                   rect:CGRectMake(98 * (index - 3), 0, 98, 87)];
  }
  balloon_.position = CGPointMake(300, 230);
  [self addChild:balloon_];
  [[KWMusicManager sharedManager] playEffect:@"se1.caf"];
}

-(void)onPresent {
  [[KWMusicManager sharedManager] playEffect:@"se2.caf"];
  rochka_ = [KWAnimation spriteWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"rochka.png"] 
                                           size:CGSizeMake(112, 110) 
                                          delay:0.3];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if (isYes_) {
    [self onPresent];
  } else {
    [self onGameOver];
  }
  return YES;
}

@end