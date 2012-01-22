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
    score_ = 0;
    isYes_ = NO;
    isTouched_ = YES;
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
    rochka_ = [CCSprite spriteWithFile:@"rochka.png" rect:CGRectMake(0, 0, 112, 100)];
    
    CCSprite* bag = [CCSprite spriteWithFile:@"bag.png"];
    rochka_.position = CGPointMake(390, 175);
    rud.position = CGPointMake(380, 140);
    bag.position = CGPointMake(405, 145);
    [self addChild:rud];
    [self addChild:rochka_];
    [self addChild:bag];
    [self onReady];
    [self addChild:frame];
    //scoreLabel_ = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:24];
    scoreLabel_ = [CCLabelTTF labelWithString:@"0" 
                                   dimensions:CGSizeMake(200, 50) 
                                    alignment:UITextAlignmentRight
                                     fontName:@"Marker Felt" 
                                     fontSize:24];
    scoreLabel_.position = ccp(330, 7);
    scoreLabel_.color = ccc3(20, 20, 20);
    [self addChild:scoreLabel_];
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
  timer_ = [KWTimer timerWithMax:2];
  timer_.looping = YES;
  [timer_ setOnCompleteListener:self selector:@selector(onCount)];
  [timer_ play];
}

- (void)onGameOver {
  [timer_ stop];
  CCSprite* jed = [KWAnimation spriteWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"jed.png"] 
                                                 size:CGSizeMake(100.5, 126) 
                                                delay:0.3];
  float x = rochka_.position.x;
  jed.position = CGPointMake(x, [CCDirector sharedDirector].screenSize.height);
  [self addChild:jed];
  [[KWMusicManager sharedManager] playEffect:@"se3.caf"];
  [rochka_ runAction:[CCMoveTo actionWithDuration:1.0 position:CGPointMake(x, -100)]];
  CCSequence* seq = [CCSequence actions:[CCMoveTo actionWithDuration:1.0 position:CGPointMake(x, -100)],
                     [CCDelayTime actionWithDuration:2],
                     [CCCallBlock actionWithBlock:^{
    NSLog(@"GameOver");
  }], nil];
  [jed runAction:seq];
}

- (void)onCount {
  if (!isTouched_ && isYes_) {
    [self onGameOver];
    return;
  }
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
  isTouched_ = NO;
}

-(void)onPresent {
  [timer_ stop];
  [[KWMusicManager sharedManager] playEffect:@"se2.caf"];
  CCAnimate* anim = [KWAnimation animationWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"rochka.png"]
                                                      size:CGSizeMake(112, 100) 
                                                     delay:0.1];
  __block KWTimer* timer = timer_;
  __block MainLayer* layer = self;
  id restart = [CCCallBlockN actionWithBlock:^(CCNode* node){
    CCSprite* present = [CCSprite spriteWithFile:@"present.png"];
    present.position = node.position;
    CCDirector* director = [CCDirector sharedDirector];
    id suicide = [CCCallBlockN actionWithBlock:^(CCNode* node) {
      [layer removeChild:node cleanup:YES];
    }];
    [present runAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:1.0 
                                                                 position:CGPointMake(director.screenCenter.x, -100)] 
                                         two:suicide]];
    [timer play];
    score_ += 100;
    [scoreLabel_ setString:[NSString stringWithFormat:@"%d", score_]];
    [layer addChild:present];
  }];
  CCSequence* seq = [CCSequence actions:anim, restart, nil];
  [rochka_ runAction:seq];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if(!timer_.active) return NO;
  if (isYes_) {
    [timer_ pause];
    isTouched_ = YES;
    [self onPresent];
  } else {
    [self onGameOver];
  }
  return YES;
}

@end