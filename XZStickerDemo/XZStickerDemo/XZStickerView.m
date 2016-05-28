
#import "XZStickerView.h"

#define Margin  10.0f

@interface XZStickerView()<UIGestureRecognizerDelegate>{
    
    /** 起始宽度*/
    CGFloat _originalWidth;
    /** 起始高度*/
    CGFloat _originalHeight;
    
    CGPoint _initalPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    
    CGFloat _scale;
    CGFloat _arg;
    
    CGRect _initalFrame;
    
}

@property (nonatomic, strong) UIImageView *operationView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *borderView;

@end

@implementation XZStickerView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        _originalWidth = frame.size.width;
        _originalHeight = frame.size.height;
        
        self.multipleTouchEnabled = YES;
        
        [self addSubview:self.borderView];
        [self addSubview:self.imageView];
        [self addSubview:self.operationView];
        [self addGesture];
        [self setScale:1];
    }
    return self;
}

#pragma mark - Setter && Getter
- (UIView *)borderView{

    if (!_borderView) {
        
        _borderView = [[UIView alloc] initWithFrame:CGRectMake(Margin, Margin, CGRectGetWidth(self.frame)-Margin*2, CGRectGetHeight(self.frame)-Margin*2)];
        _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
        _borderView.layer.borderWidth = 1.0f;
        _borderView.backgroundColor = [UIColor clearColor];
        
        _borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _borderView;
}

- (UIImageView *)operationView{

    if (!_operationView) {
        
        _operationView = [[UIImageView alloc] initWithFrame:CGRectMake(_originalWidth-50.0f, _originalHeight-50.0f, 50, 50)];
        _operationView.image = [UIImage imageNamed:@"operation"];
        [_operationView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture_Method:)]];
        _operationView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _operationView.userInteractionEnabled = YES;
        
    }
    return _operationView;
}

- (UIImageView *)imageView{

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Margin*2, Margin*2, _originalWidth - Margin*4, _originalHeight- Margin*4)];
        _imageView.image = [UIImage imageNamed:@"love"];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _imageView;
}

#pragma mark - Private_Methods
- (void)setScale:(CGFloat)scale{
    
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    self.bounds = CGRectMake(0, 0, _originalWidth*_scale, _originalHeight*_scale);
    
    self.transform = CGAffineTransformMakeRotation(_arg);
}

- (void)addGesture{

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
    [self addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    pinchGesture.delegate = self;
    [self addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)];
    rotateGesture.delegate = self;
    [self addGestureRecognizer:rotateGesture];
}

- (UIImage *)generateImage{

    self.operationView.hidden = YES;
    self.borderView.hidden = YES;
    
    UIImageView *imageView = (UIImageView *)self.superview;
    
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [imageView.image drawInRect:imageView.bounds];
    
    CGContextSaveGState(context);


    // Center the context around the view's anchor point
    CGContextTranslateCTM(context, [self center].x, [self center].y);
    // Apply the view's transform about the anchor point
    CGContextConcatCTM(context, [self transform]);
    // Offset by the portion of the bounds left of and above the anchor point
    CGContextTranslateCTM(context,
                          -[self bounds].size.width * [[self layer] anchorPoint].x,
                          -[self bounds].size.height * [[self layer] anchorPoint].y);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - UIGesture_Methods

- (void)panGesture_Method:(UIPanGestureRecognizer *)panGesture{
    
    CGPoint point = [panGesture translationInView:self.superview];
    
    static CGFloat tmpR = 0;
    static CGFloat tmpA = 0;
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
        _initalPoint = [self.superview convertPoint:self.operationView.center fromView:self];
        
        CGPoint p = CGPointMake(_initalPoint.x - self.center.x, _initalPoint.y - self.center.y);
        
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    point = CGPointMake(_initalPoint.x + point.x - self.center.x, _initalPoint.y+ point.y-self.center.y);
    
    CGFloat R = sqrt(point.x*point.x + point.y*point.y);
    CGFloat arg = atan2(point.y, point.x);
    
    _arg = _initialArg+arg - tmpA;

    [self setScale:MAX(_initialScale * R / tmpR, (50.0f+20.0f)/_originalWidth)];
    
}

- (void)translate:(UIPanGestureRecognizer *)gesture{
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _initalPoint = [gesture translationInView:self.superview];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged){
        
        CGPoint point = [gesture translationInView:self.superview];
        CGPoint center = CGPointMake(self.center.x + point.x - _initalPoint.x,
                                     self.center.y + point.y - _initalPoint.y);
        
        self.center = center;
        _initalPoint = point;
    }
}


- (void)scale:(UIPinchGestureRecognizer *)gesture{

    CGFloat scale = gesture.scale;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        _initalFrame = self.frame;

    }if (gesture.state == UIGestureRecognizerStateChanged){
        
        self.bounds = CGRectMake(0, 0, _initalFrame.size.width*scale, _initalFrame.size.height*scale);
    }
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state ==UIGestureRecognizerStateCancelled || gesture.state ==UIGestureRecognizerStateFailed) {
        
        
        _scale =    self.bounds.size.width/100;

    }
    
}


- (void)rotate:(UIRotationGestureRecognizer *)gesture{
    
    
    CGFloat rotate = gesture.rotation;

    self.transform = CGAffineTransformRotate(self.transform, rotate);
    gesture.rotation = 0;

    static CGFloat tmpC = 0;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {

       CGPoint point = [self.superview convertPoint:self.operationView.center fromView:self];
        
        CGPoint a = CGPointMake(point.x - self.center.x, point.y - self.center.y);
        
        _initialArg = _arg;
        
        tmpC = atan2(a.y, a.x);
  
    }
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state ==UIGestureRecognizerStateCancelled || gesture.state ==UIGestureRecognizerStateFailed) {
      
        CGPoint point1 =  [self.superview convertPoint:self.operationView.center fromView:self];
        
        CGPoint point = CGPointMake(point1.x - self.center.x,point1.y - self.center.y);

        
        _arg = atan2(point.y, point.x) +_initialArg -tmpC;

    }

}

#pragma mark - UIGestureRecognizer_Delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end