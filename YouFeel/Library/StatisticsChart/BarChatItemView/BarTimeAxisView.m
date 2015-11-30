//
//  BarTimeAxisView.m
//  StatisticsDemo
//
//  Created by 满孝意 on 15/11/26.
//  Copyright © 2015年 ManYi. All rights reserved.
//

#import "BarTimeAxisView.h"
#import "BarTimeAxisData.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#define BAR_WIDTH_MAX 100
#define BAR_WIDTH_MIN 3
#define BAR_WIDTH_DEFAULT 20
#define BAR_SPACES_DEFAULT 10
#define HORIZONTAL_PADDING 20
#define VERTICAL_PADDING 30
#define HORIZONTAL_START_LINE 0.2
#define VERTICAL_START_LINE 0.2
#define VERTICALE_DATA_SPACES 20
#define LABEL_DIM 20

@interface BarTimeAxisView ()

@property CGPoint contentScroll;
@property int maxHeight;
@property int maxWidth;

@end

@implementation BarTimeAxisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.barWidth=BAR_WIDTH_DEFAULT;
        self.spaceBetweenBars=BAR_SPACES_DEFAULT;
        self.backgroundColor=[UIColor colorWithWhite:1.0 alpha:1.0];
        self.linesColor=[UIColor blackColor];
        self.numbersColor=[UIColor clearColor];
        self.numbersTextColor=[UIColor blackColor];
        self.dateColor=[UIColor blackColor];
        self.contentScroll=CGPointZero;
        self.numberOfVerticalElements=8;
        // 长条颜色
        self.barColor=[UIColor colorWithRed:0.23 green:0.69 blue:1.0 alpha:1.0];
        self.textColor=[UIColor colorWithRed:0.4 green:0.8 blue:0.8 alpha:0.5];
        self.dottedLineColor=[UIColor colorWithRed:0.8 green:0.4 blue:0.4 alpha:1];
        self.barOuterLine=[UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:0.8];
        // TODO: ---------- 调试表头 ----------
        self.datesBarText=@"";
        self.tasksBarText=@"";
        self.fontName=@"Helvetica";
        self.dateFontSize=12;
        self.titlesFontSize=20;
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    float minOfTwo=MIN(self.bounds.size.width, self.bounds.size.height);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    
    CGFloat dashPattern[]= {6.0, 5};
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0.0, dashPattern, 2);
    
    UIFont * font=[UIFont fontWithName:self.fontName size:self.dateFontSize];
    
    // TODO: ---------- 调试表头 ----------
    //[self drawString:@"Day" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -15) WithFont:font WithColor:self.dateColor WithContext:context];
    
    //[self drawString:@"Month" atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -30) WithFont:font WithColor:self.dateColor WithContext:context];
    
    //write tasks and date
    font=[UIFont fontWithName:self.fontName size:self.titlesFontSize];
    
    [self drawString:self.datesBarText atPoint:CGPointMake(self.bounds.size.width/2, 7) WithFont:font WithColor:self.textColor WithContext:context];
    
    CGAffineTransform transform=CGAffineTransformMakeTranslation(25, self.bounds.size.height / 2.f);
    CGFloat rotation = M_PI / 2.f;
    transform = CGAffineTransformRotate(transform,rotation);
    //NSLog(@"height %f",self.bounds.size.height/2.f);
    CGContextSaveGState(context);
    CGContextConcatCTM(context, transform);
    [self drawString:self.tasksBarText atPoint:CGPointMake(0, 0) WithFont:font WithColor:self.textColor WithContext:context];
    
    CGContextRestoreGState(context);
    
    font=[UIFont fontWithName:self.fontName size:self.dateFontSize];
    
    //vertical numbers
    for (int i=0; i<=self.numberOfVerticalElements; i++) {
        int height=VERTICALE_DATA_SPACES* i;
        float verticalLine=height+VERTICAL_START_LINE*minOfTwo-self.contentScroll.y;
        if (verticalLine>VERTICAL_START_LINE*minOfTwo) {
            [self.dottedLineColor set];
            CGContextMoveToPoint(context, HORIZONTAL_START_LINE*minOfTwo, verticalLine);
            CGContextAddLineToPoint(context, self.bounds.size.width, verticalLine);
            CGContextStrokePath(context);
            NSString * numberString=[NSString stringWithFormat:@"%d",i];
            [self.numbersColor set];
            CGContextFillRect(context, CGRectMake((HORIZONTAL_START_LINE*minOfTwo)/2-4, verticalLine-8, 15, 15));
            
            [self drawString:numberString atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)/2+4, verticalLine-8) WithFont:font WithColor:self.numbersTextColor WithContext:context];
        }
    }
    
    
    //set the line solid
    CGFloat  normal=1;
    
    CGContextSetLineDash(context,0,&normal,0);
    
    int index=0;
    
    NSString * yearString=@"";
    for (BarTimeAxisData * dataObject in self.dataSource) {
        int height=VERTICALE_DATA_SPACES* [dataObject.number intValue];
        
        if (VERTICAL_START_LINE*minOfTwo-self.contentScroll.y <VERTICAL_START_LINE*minOfTwo) {
            height-=self.contentScroll.y;
        }
        float xPosition=HORIZONTAL_START_LINE*minOfTwo+(index+1)* self.spaceBetweenBars + index * self.barWidth+self.contentScroll.x;
        
        if (xPosition>=HORIZONTAL_START_LINE*minOfTwo && xPosition<self.bounds.size.width ){
            [self.dateColor set];
            
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dataObject.date];
            
            NSInteger year=[components year];
            yearString=[NSString stringWithFormat:@"%ld",(long)year];
            
            NSInteger day = [components day];
            NSString * dayString=[NSString stringWithFormat:@"%ld",(long)day];
            [self drawString:dayString atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo-15) WithFont:font WithColor:self.numbersTextColor WithContext:context];
            
            // TODO: ---------- 调试X轴月份 ----------
            //NSInteger month = [components month];
            //NSString * monthString=[NSString stringWithFormat:@"%ld",(long)month];
            //[self drawString:monthString atPoint:CGPointMake(xPosition+self.barWidth/2, VERTICAL_START_LINE*minOfTwo -30) WithFont:font WithColor:self.numbersTextColor WithContext:context];
            
        }
        
        
        if (height>0) {
            // TODO: -----------------  调试柱状条  -----------------
            if (xPosition>=HORIZONTAL_START_LINE*minOfTwo && xPosition<self.bounds.size.width ) {
                CGRect barRect=CGRectMake(xPosition, VERTICAL_START_LINE*minOfTwo, self.barWidth, height);
                [self.barOuterLine set];
                CGContextStrokeRect(context, barRect);
                [self.barColor set];
                UIRectFill(barRect);
                
                CGRect barRect1=CGRectMake(xPosition, VERTICAL_START_LINE*minOfTwo+height, self.barWidth, 5);
                [[UIColor redColor] set];
                CGContextStrokeRect(context, barRect1);
                [[UIColor redColor] set];
                UIRectFill(barRect1);
            
                
            }
            else if(xPosition+self.barWidth >HORIZONTAL_START_LINE*minOfTwo  && xPosition<HORIZONTAL_START_LINE*minOfTwo )
            {
                
                [self.barColor set];
                UIRectFill(CGRectMake(HORIZONTAL_START_LINE*minOfTwo, VERTICAL_START_LINE*minOfTwo, self.barWidth-(HORIZONTAL_START_LINE*minOfTwo-xPosition), height));
            }
        }
        
        index++;
    }
    
    // TODO: ---------- 调试Z轴年份 ----------
    //[self drawString:yearString atPoint:CGPointMake((HORIZONTAL_START_LINE*minOfTwo)-35, VERTICAL_START_LINE*minOfTwo -45) WithFont:font WithColor:self.numbersTextColor WithContext:context];
    
    // draw axes
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, HORIZONTAL_START_LINE*minOfTwo, VERTICAL_START_LINE*minOfTwo);
    [self.linesColor set];
    
    CGContextAddLineToPoint(context, HORIZONTAL_START_LINE*minOfTwo, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, HORIZONTAL_START_LINE*minOfTwo, VERTICAL_START_LINE*minOfTwo);
    CGContextAddLineToPoint(context, self.bounds.size.width, VERTICAL_START_LINE*minOfTwo);
    CGContextStrokePath(context);
}


#pragma mark setDataSource
- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource=dataSource;
    
    //calculate the limit of height
    _maxHeight=0;
    for (BarTimeAxisData * dataObject in _dataSource) {
        int height=VERTICALE_DATA_SPACES* [dataObject.number intValue];
        _maxHeight=MAX(height, _maxHeight);
    }
    _maxHeight-=self.spaceBetweenBars;
    //calculate the limit of width
    _maxWidth=([_dataSource count]-1)*(self.barWidth+self.spaceBetweenBars);
}

#pragma mark setDataSource
- (void)setColorArray:(NSArray *)colorArray
{
    _colorArray = colorArray;
    
    for (NSString *colorStr in _colorArray) {
        self.barColor = colorWithHexString111(colorStr);
    }
}

#pragma mark touch handling
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation=[[touches anyObject] locationInView:self];
    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
    float xDiffrance=touchLocation.x-prevouseLocation.x;
    float yDiffrance=touchLocation.y-prevouseLocation.y;
    
    _contentScroll.x+=xDiffrance;
    _contentScroll.y+=yDiffrance;
    
    if (_contentScroll.x >0) {
        _contentScroll.x=0;
    }
    if(_contentScroll.y<0)
    {
        _contentScroll.y=0;
    }
    
    if (-_contentScroll.x>self.maxWidth) {
        _contentScroll.x=-self.maxWidth;
    }
    if (_contentScroll.y>self.maxHeight) {
       _contentScroll.y=self.maxHeight;
    }
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma mark draw attributed string
-(void) drawString:(NSString *) string atPoint:(CGPoint) point WithFont:(UIFont *) font WithColor:(UIColor *) color WithContext:(CGContextRef) context
{
    
    NSDictionary * attribut=@{NSForegroundColorAttributeName:color,NSFontAttributeName:font};
    
    CGSize sizeOfStr=[string sizeWithAttributes:attribut];
    CGPathRef path=CGPathCreateWithRect(CGRectMake(point.x-(sizeOfStr.width/2), point.y, sizeOfStr.width, sizeOfStr.height+2), &CGAffineTransformIdentity);
    //debug
    //    CGContextFillRect(context, CGRectMake(point.x-(sizeOfStr.width/2), point.y, sizeOfStr.width, sizeOfStr.height+2));
    
    NSAttributedString * dateAttString=[[NSAttributedString alloc] initWithString:string attributes:attribut];
    
    
    CTFramesetterRef framesetter =CTFramesetterCreateWithAttributedString((CFAttributedStringRef)dateAttString);
    CTFrameRef frame =CTFramesetterCreateFrame(framesetter,CFRangeMake(0, [dateAttString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    //release
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

UIColor *colorWithHexString111(NSString *stringToConvert) {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.f];
}

@end
