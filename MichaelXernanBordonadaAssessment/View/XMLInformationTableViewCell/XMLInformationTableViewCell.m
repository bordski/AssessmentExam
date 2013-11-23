//
//  XMLInformationTableViewCell.m
//  MichaelXernanBordonadaAssessment
//
//  Created by Diversify BPO on 11/23/13.
//
//

#import "XMLInformationTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation XMLInformationTableViewCell

@synthesize image = _image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImageView *)image
{
    if (_image) {
        
        [_image.layer setBorderColor:[UIColor blackColor].CGColor];
        [_image.layer setBorderWidth:1.0];
        
    }
    
    return _image;
}

@end
