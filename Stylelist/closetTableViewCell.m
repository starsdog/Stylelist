//
//  closetTableViewCell.m
//  Stylelist
//
//  Created by Splashtop on 13/8/21.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "closetTableViewCell.h"

@implementation closetTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        //prepare cell content here
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 295, 30)];
        self.descriptionLabel.backgroundColor = [UIColor redColor];
        self.descriptionLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        self.closetCellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 390)];
        //self.closetCellView.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.closetCellView];
        
        //[self addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
