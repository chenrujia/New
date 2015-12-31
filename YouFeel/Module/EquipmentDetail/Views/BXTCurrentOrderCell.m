//
//  BXTCurrentOrderCell.m
//  YouFeel
//
//  Created by 满孝意 on 15/12/30.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "BXTCurrentOrderCell.h"

@implementation BXTCurrentOrderCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cell";
    BXTCurrentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BXTCurrentOrderCell" owner:nil options:nil] lastObject];
    }
    
    cell.locationView.text = @"来发掘的历史快放假发掘的历史快放假掘的历史快放假啊收导弹啊收到了房间";
    cell.typeView.text = @"阿的来发掘的历史快放假掘的历史快放假啊收到了历史快放假掘的历史快放假啊收来发掘的历史快放假掘的历史快放假啊收房说第做法";
    cell.describeView.text = @"地对地来发掘的历史快放假掘的历史快放假啊收来发掘的历史快放假掘的历史快放假啊收来发掘的历史快放假掘的历史快放假啊收导弹";

    CGSize locationSize = MB_MULTILINE_TEXTSIZE(cell.locationView.text, [UIFont boldSystemFontOfSize:15.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
    CGSize typeSize = MB_MULTILINE_TEXTSIZE(cell.typeView.text, [UIFont boldSystemFontOfSize:15.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
    CGSize describeSize = MB_MULTILINE_TEXTSIZE(cell.describeView.text, [UIFont boldSystemFontOfSize:15.f], CGSizeMake(SCREEN_WIDTH - 30.f, 500), NSLineBreakByWordWrapping);
    
    cell.cellHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1 + locationSize.height + typeSize.height + describeSize.height - 3 * 17;
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
