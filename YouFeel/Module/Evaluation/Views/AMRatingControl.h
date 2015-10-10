//
//  AMRatingControl.h
//  RatingControl
//


#import <UIKit/UIKit.h>
@class AMRatingControl;

@protocol AMRateDelegate <NSObject>

/**
 *  @param rate   新的评分值
 */
- (void)rateNumber:(NSInteger)rate withRateControl:(AMRatingControl *)ctr;

@end

@interface AMRatingControl : UIControl
{
	UIImage *_emptyImage, *_solidImage;
    UIColor *_emptyColor, *_solidColor;
    NSInteger _maxRating;
}


/**************************************************************************************************/
#pragma mark - Getters and Setters

@property (nonatomic, assign) NSInteger rating;


/**************************************************************************************************/
#pragma mark - Birth & Death

@property (assign, nonatomic) id<AMRateDelegate> delegate;


/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyColor & solidColor
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location
            emptyColor:(UIColor *)emptyColor
            solidColor:(UIColor *)solidColor
          andMaxRating:(NSInteger)maxRating;

/**
 * @param location : position of the rating control in your view
 * The control will manage its own width/height (kind of like UIActivityIndicator)
 * @param emptyImage & solidImage can both be nil, or not even a dot or a star (a any images you want!)
 * If either of these parameters are nil, the class will draw its own stars
 * @param maxRating
 */
- (id)initWithLocation:(CGPoint)location
            emptyImage:(UIImage *)emptyImageOrNil
            solidImage:(UIImage *)solidImageOrNil
          andMaxRating:(NSInteger)maxRating;



@end
