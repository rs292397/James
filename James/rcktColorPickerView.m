//
//  rcktColorPickerView.m
//  James
//
//  Created by Modesty & Roland on 03/09/14.
//  Copyright (c) 2014 Rckt. All rights reserved.
//

#import "rcktColorPickerView.h"
#import "rckt.h"

CGFloat const rcktColorPickerWheelViewDefaultMargin = 10.0f;
CGFloat const rcktColorPickerWheelLabelHeight = 30.0f;
CGFloat const rcktColorPickerWheelViewCrossHairshWidthAndHeight = 38.0f;

@interface rcktColorPickerView () {
    NSString *lid;
}

@property (nonatomic, strong) UIImageView* hueSaturationImage;
@property (nonatomic, strong) UIView* colorBubble;
@property (nonatomic, assign) CGFloat hue;
@property (nonatomic, assign) CGFloat saturation;
@property (nonatomic, strong) UIView* colorPreviewView;

@end

@implementation rcktColorPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ((self = [super initWithFrame:frame]) == nil) { return nil; }
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self createViews];
        self.color = [UIColor redColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void) createViews
{
    //initialize new mutable data
    NSMutableData *data = [[NSMutableData alloc] init];
    self.receivedData = data;
    
    UIColor* borderColor = [UIColor colorWithWhite:0.0f alpha:0.1f];
    _colorPreviewView = [[UIView alloc] init];
    _colorPreviewView.layer.borderWidth = 1.0f;
    [self addSubview:_colorPreviewView];
    
    _hueSaturationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drcolorpicker-colormap.png"]];
    _hueSaturationImage.layer.borderWidth = 1.0f;
    _hueSaturationImage.layer.borderColor = borderColor.CGColor;
    [self addSubview:_hueSaturationImage];
    
    _colorBubble = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(_hueSaturationImage.frame), CGRectGetMidX(_hueSaturationImage.frame),rcktColorPickerWheelViewCrossHairshWidthAndHeight, rcktColorPickerWheelViewCrossHairshWidthAndHeight)];
    
    UIColor* bubbleBorderColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    _colorBubble.layer.cornerRadius = rcktColorPickerWheelViewCrossHairshWidthAndHeight * 0.5f;
    _colorBubble.layer.borderColor = bubbleBorderColor.CGColor;
    _colorBubble.layer.borderWidth = 2;
    _colorBubble.layer.shadowColor = [UIColor blackColor].CGColor;
    _colorBubble.layer.shadowOffset = CGSizeZero;
    _colorBubble.layer.shadowRadius = 1;
    _colorBubble.layer.shadowOpacity = 0.5f;
    _colorBubble.layer.shouldRasterize = YES;
    _colorBubble.layer.rasterizationScale = UIScreen.mainScreen.scale;
    [self addSubview:_colorBubble];
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.colorPreviewView.frame = CGRectMake(rcktColorPickerWheelViewDefaultMargin, rcktColorPickerWheelViewDefaultMargin, self.frame.size.width - (rcktColorPickerWheelViewDefaultMargin*2), rcktColorPickerWheelLabelHeight);
    
    self.hueSaturationImage.frame = CGRectMake(rcktColorPickerWheelViewDefaultMargin,
                                               (rcktColorPickerWheelViewDefaultMargin*2) +  rcktColorPickerWheelLabelHeight,
                                               CGRectGetWidth(self.frame) - (rcktColorPickerWheelViewDefaultMargin * 2),
                                               CGRectGetHeight(self.frame) - (rcktColorPickerWheelViewDefaultMargin*3) - rcktColorPickerWheelLabelHeight);
    
    [self updateColorBubblePosition];
}


- (void) initColor:(UIColor *) newColor lightID:(NSString *)l
{
    lid = l;
    if (![_color isEqual:newColor])
    {
        [newColor getHue:&_hue saturation:&_saturation brightness:NULL alpha:NULL];
        _color = [newColor copy];
        self.colorBubble.backgroundColor = _color;
        self.colorPreviewView.backgroundColor = _color;
        [self updateColorBubblePosition];
    }
}

- (UIColor*) getColor {
    return _color;
}

- (void) setColorBubblePosition:(CGPoint)p
{
    self.colorBubble.center = p;
}

- (void) updateColorBubblePosition
{
    CGPoint hueSatPosition;
    
    hueSatPosition.x = (self.hue * self.hueSaturationImage.frame.size.width) + self.hueSaturationImage.frame.origin.x;
    hueSatPosition.y = (1.0f - self.saturation) * self.hueSaturationImage.frame.size.height + self.hueSaturationImage.frame.origin.y;
    [self setColorBubblePosition:hueSatPosition];
}

- (void) updateHueSatWithMovement:(CGPoint)position
{
	self.hue = (position.x - self.hueSaturationImage.frame.origin.x) / self.hueSaturationImage.frame.size.width;
	self.saturation = 1.0f -  (position.y - self.hueSaturationImage.frame.origin.y) / self.hueSaturationImage.frame.size.height;
    
	_color = [UIColor colorWithHue:self.hue saturation:self.saturation brightness:1.0f alpha:1.0f];
    self.colorBubble.backgroundColor = _color;
    self.colorPreviewView.backgroundColor = _color;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    
	for (UITouch* touch in touches)
    {
		[self handleTouchEvent:[touch locationInView:self]];
    }
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesMoved:touches withEvent:event];
    
	for (UITouch* touch in touches)
    {
		[self handleTouchEvent:[touch locationInView:self]];
	}
}

- (void) handleTouchEvent:(CGPoint)position
{
	if (CGRectContainsPoint(self.hueSaturationImage.frame,position))
    {
        [self setColorBubblePosition:position];
		[self updateHueSatWithMovement:position];
        [self sendColor];
	}
}



- (void) sendColor {

    NSString *urlServer = [[rckt alloc] GetServerURL];
    NSString *postData;
    postData = [NSString stringWithFormat:@"{\"command\":\"3\", \"on\":\"true\", \"hue\": \"%.0f\", \"sat\": \"%.0f\"}", self.hue*360.0, self.saturation*100.0];
    NSString *url = [NSString stringWithFormat:@"%@/controlLight/%@", urlServer, lid];
    [self doAPIrequestPUT:[NSURL URLWithString:url] postData:postData];

}

- (void) doAPIrequestPUT: (NSURL*) url postData:(NSString*) postData{
    
    //NSLog(@"%@", url.absoluteString);
    
    //initialize url that is going to be fetched.
    
    //initialize a request from url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //set http method
    [request setHTTPMethod:@"PUT"];
    //initialize a post data
    //NSString *postData = [NSString stringWithFormat:@"j_username=role&j_password=tomcat"];
    //set request content type we MUST set this value.
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    //initialize a connection from request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.connection = connection;
    
    //start the connection
    [connection start];
    
}



/*
 this method might be calling more than one times according to incoming data size
 */
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.receivedData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.receivedData setLength:0];
}
/*
 if there is an error occured, this method will be called by connection
 */
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@" , error);
}

/*
 if data is successfully received, this method will be called by connection
 */
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //NSLog(@"%@", [self.connection.currentRequest.URL absoluteString]);
    //NSError* error;
    //initialize convert the received data to string with UTF8 encoding
    //NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    
}


@end
