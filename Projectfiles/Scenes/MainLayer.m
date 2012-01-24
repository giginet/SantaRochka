//
//  MainLayer.m
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "KWMusicManager.h"
#import "MainLayer.h"
#import "ResultLayer.h"

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
    interval_ = 2;
    isYes_ = NO;
    isTouched_ = YES;
    mainLayer_ = [[CCLayer alloc] init];
    for(NSString* bgm in [NSArray arrayWithObjects:@"se1.caf", @"se2.caf", @"se3.caf", nil]){
      [[KWMusicManager sharedManager] preloadEffect:bgm];
    }
    [[KWMusicManager sharedManager] preloadBg:@"afternoon_lesson.caf"];
    CCLayer* bgLayer = [[CCLayer alloc] init];
    KWScrollLayer* background = [KWScrollLayer layerWithFile:@"background.png"];
    background.velocity = [KWVector vectorWithPoint:CGPointMake(1.5, 0)];
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
    [mainLayer_ addChild:rud];
    [mainLayer_ addChild:rochka_];
    [mainLayer_ addChild:bag];
    [self addChild:mainLayer_];
    [self addChild:frame];
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
  [self onReady];
}

- (void)onReady {
  CCSprite* ready = [CCSprite spriteWithFile:@"ready.png"];
  ready.position = CGPointMake(190, 250);
  ready.opacity = 0;
  [KWMusicManager sharedManager].bgVolume = 0.5;
  CCSequence* seq = [CCSequence actions:[CCFadeIn actionWithDuration:0.25], 
                     [CCDelayTime actionWithDuration:2], 
                     [CCFadeOut actionWithDuration:0.25],
                     [CCCallFunc actionWithTarget:self selector:@selector(onGameStart)],
                     nil];
  
  [ready runAction:seq];
  [mainLayer_ addChild:ready];
  
  CCSprite* stage = [CCSprite spriteWithFile:@"stage1.png"];
  stage.position = CGPointMake(90, 120);
  stage.opacity = 0;
  [stage runAction:[CCFadeIn actionWithDuration:0.25]];
  [mainLayer_ addChild:stage];
}

- (void)onGameStart {
  timer_ = [KWTimer timerWithMax:interval_];
  timer_.looping = YES;
  [timer_ setOnCompleteListener:self selector:@selector(onCount)];
  [timer_ play];
  [KWMusicManager sharedManager].bgVolume = 1.0;
  [self onCount];
}

- (void)onGameOver {
  [timer_ stop];
  CCSprite* jed = [KWAnimation spriteWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"jed.png"] 
                                                 size:CGSizeMake(100.5, 126) 
                                                delay:0.3];
  float x = rochka_.position.x;
  jed.position = CGPointMake(x, [CCDirector sharedDirector].screenSize.height);
  [mainLayer_ addChild:jed];
  [[KWMusicManager sharedManager] playEffect:@"se3.caf"];
  [rochka_ runAction:[CCMoveTo actionWithDuration:1.0 position:CGPointMake(x, -100)]];
  [[[KWMusicManager sharedManager] backgroundTrack] 
   fadeTo:0 
   duration:3.0f 
   target:nil 
   selector:nil];
  CCSequence* seq = [CCSequence actions:[CCMoveTo actionWithDuration:1.0 position:CGPointMake(x, -100)],
                     [CCDelayTime actionWithDuration:2],
                     [CCCallBlock actionWithBlock:^{
    ResultLayer* rl = [[ResultLayer alloc] initWithScore:score_];
    id scene = [[CCScene alloc] init];
    [scene addChild:rl];
    CCTransitionFade* transition = [CCTransitionFade transitionWithDuration:0.5f 
                                                                      scene:scene];
    [[CCDirector sharedDirector] replaceScene:transition];
  }], nil];
  [jed runAction:seq];
}

- (void)onCount {
  if (!isTouched_ && isYes_) {
    [self onGameOver];
    return;
  }
  [mainLayer_ removeChild:balloon_ cleanup:YES];
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
  [mainLayer_ addChild:balloon_];
  [[KWMusicManager sharedManager] playEffect:@"se1.caf"];
  isTouched_ = NO;
  interval_ = MAX(0.6, interval_ - 0.015);
  [timer_ set:interval_];
}

-(void)onPresent {
  [timer_ stop];
  [[KWMusicManager sharedManager] playEffect:@"se2.caf"];
  CCAnimate* anim = [KWAnimation animationWithTextureAtlas:[[CCTextureCache sharedTextureCache] addImage:@"rochka.png"]
                                                      size:CGSizeMake(112, 100) 
                                                     delay:0.10];
  __block KWTimer* timer = timer_;
  __block CCLayer* layer = mainLayer_;
  CCSprite* love = [CCSprite spriteWithFile:@"love.png"];
  love.position = ccp(balloon_.contentSize.width / 2, 
                      balloon_.contentSize.height / 2);
  [balloon_ addChild:love];
  id shoot = [CCCallBlockN actionWithBlock:^(CCNode* node){
    CCSprite* present = [CCSprite spriteWithFile:@"present.png"];
    present.position = node.position;
    id suicide = [CCCallBlockN actionWithBlock:^(CCNode* node) {
      [layer removeChild:node cleanup:YES];
    }];
    [present runAction:[CCSequence actionOne:[CCMoveTo actionWithDuration:1.0 
                                                                 position:CGPointMake(0, -100)] 
                                         two:suicide]];
    [timer play];
    score_ += 100;
    [scoreLabel_ setString:[NSString stringWithFormat:@"%d", score_]];
    [layer addChild:present];
  }];
  CCSequence* seq = [CCSequence actions:anim, shoot, nil];
  [rochka_ runAction:seq];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  if(!timer_.active) return NO;
  if (isYes_) {
    if (!isTouched_){
      [timer_ pause];
      isTouched_ = YES;
      [self onPresent];
    }
  } else {
    [self onGameOver];
  }
  return YES;
}

@end