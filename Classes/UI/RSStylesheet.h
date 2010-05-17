//
//  RSStylesheet.h
//  Resale
//
//  Created by A Jesse Jiryu Davis on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Three20UI/Three20UI.h>


@interface RSStylesheet : TTDefaultStyleSheet {
	TTImageStyle* _imageStyle;
}

@property (nonatomic,readonly) TTImageStyle* imageStyle;

@end
