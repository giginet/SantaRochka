//
//  MainLayer.h
//  SantaRochka
//
//  Created by  on 2012/1/22.
//  Copyright (c) 2012 Kawaz. All rights reserved.
//

#import "heqet.h"

@interface MainLayer : KWLayer {
  BOOL isYes_;
  CCSprite* balloon_;
  CCSprite* rochka_;
  KWTimer* timer_;
}

@end