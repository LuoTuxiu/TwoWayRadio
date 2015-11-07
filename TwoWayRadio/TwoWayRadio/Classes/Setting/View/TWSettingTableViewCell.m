//
//  TWSettingTableViewCell.m
//  TwoWayRadio
//
//  Created by xulei on 15/10/1.
//  Copyright © 2015年 Trbocare. All rights reserved.
//

#import "TWSettingTableViewCell.h"
#import "TWSettingItem.h"
#import "TWSettingArrowItem.h"
#import "TWSettingTextItem.h"
@interface TWSettingTableViewCell()
{
    UIImageView *_arrow;
    UITextField *_text;
}
@end

@implementation TWSettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItem:(TWSettingItem *)item
{
    _item = item;
    //设置数据
    self.imageView.image =  [UIImage imageNamed:item.icon];
    self.textLabel.text  =  item.title;
    self.detailTextLabel.text = item.subtitle;
    
    if ([item isKindOfClass:[TWSettingArrowItem class]]) {
        [self settingArrow];
    }
    else if ([item isKindOfClass:[TWSettingTextItem class]]){
        [self settingTextWithItem:(TWSettingTextItem *)item];
        
        //设置选中样式是None
//        self.userInteractionEnabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        ;
    }
}

#pragma mark 设置右边的文本框
-(void)settingTextWithItem:(TWSettingTextItem *)item
{
    if (_text == nil) {
        CGRect textFrame =  CGRectMake(0, 0, TWmainScreenFrame.size.width - 100 , 44);
        _text  = [[UITextField alloc]initWithFrame:textFrame];
        _text.placeholder =  item.placeHolder;
        if ([item.title isEqualToString:@"账号"]) {
            ;
        }
    }
    
    self.accessoryView = _text;
}

#pragma mark 设置右边的箭头
-(void)settingArrow
{
    if (_arrow == nil) {
        _arrow =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    
    //设置右边图片
    self.accessoryView  = _arrow;
    
}


@end
