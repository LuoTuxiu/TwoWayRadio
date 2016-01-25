//
//  YSCommonCell.m
//  BookKeeping
//
//  Created by Kingdee on 15/2/15.
//  Copyright (c) 2015年 Kingdee. All rights reserved.
//

#import "YSCommonCell.h"


@interface YSCommonCell ()<UITextFieldDelegate>

/**
 *  右边开关
 */
@property (nonatomic, strong ) UISwitch *rightSwitch;

/**
 *  右边图片
 **/
@property (nonatomic, strong ) UIImageView *rightImage;


/**
 *  右边输入框
 **/
@property (nonatomic, strong ) UITextField *rightTextField;
@end

@implementation YSCommonCell

- (UISwitch *)switchView {
    if (_rightSwitch == nil) {
        _rightSwitch = [[UISwitch alloc] init];
        [_rightSwitch addTarget:self action:@selector(switchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _rightSwitch;
}

- (UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _rightImage;
}



-(UITextField *)rightTextField
{
    if (!_rightTextField) {
        _rightTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
        //设置文本输入框对齐方式为右对齐
        _rightTextField.textAlignment = NSTextAlignmentRight;
        _rightTextField.delegate = self;
    }
    return _rightTextField;
}


- (void)switchChange {
    if (_switchOpen) {
        _switchOpen(_rightSwitch.on);
    }
}

- (void)setSwitchOn:(BOOL)on{
    [_rightSwitch setOn:on animated:YES];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.item isKindOfClass:[DZCommonChangeFrameItem class]]) {
//        self.imageView.frame = CGRectMake(100, 10, 50, 50);
        self.imageView.x = 31;
        self.textLabel.x = self.imageView.rightX + 13;
//        self.imageView.contentMode = UIViewContentModeCenter;
//        self.textLabel.width  =200;
    }

}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"commonCell";
    YSCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[YSCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        // 标题
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        // 子标题
        self.detailTextLabel.textColor = [UIColor darkGrayColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.numberOfLines = 2;
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return self;
}

- (void)setItem:(YSCommonItem *)item {
    _item = item;
    
    // 1.设置数据
    [self setupData];
    
    // 2.设置右边的控件
    [self setupRightView];
    
    
}


- (void)setupData {
    // 1.图标
    if (self.item.icon) {
        self.imageView.image = [UIImage imageNamed:self.item.icon];
    }
    else{
        self.imageView.image = nil;
    }
    
    // 2.标题
    self.textLabel.text = self.item.title;
    
    // 3.子标题
    self.detailTextLabel.text = self.item.subtitle;
    
    // 4.右边图片
    if (self.item.rightImage) {
        self.rightImage.image = [UIImage imageNamed:self.item.rightImage];
    }else{
        self.rightImage.image = nil;
    }
}

- (void)setupRightView
{
//    self.detailTextLabel.textColor = RGB(0, 122, 255);
    if ([self.item isKindOfClass:[YSArrowItem class]]){
        // 右边是箭头
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if ([self.item isKindOfClass:[YSCheckItem class]]){
        // 右边是打钩
        YSCheckItem *checkItem = (YSCheckItem *)self.item;
        self.accessoryView = nil;
        self.accessoryType = checkItem.isChecked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }else if([self.item isKindOfClass:[YSSwitchItem class]]){
        // 右边是开关
        self.accessoryView = self.switchView;
    }else if([self.item isKindOfClass:[YSCustomItem class]]){
        // 右边是自定义的图片
        self.accessoryView = self.rightImage;
    }
    else if ([self.item isKindOfClass:[DZRightTitleItem class]]){
        self.accessoryType  = UITableViewCellAccessoryNone;
    }else if([self.item isKindOfClass:[DZRightTextFieldItem class]]){
        // 右边是自定义的文本框
        self.rightTextField.text = nil;
        self.rightTextField.placeholder = ((DZRightTextFieldItem *)self.item).dztext;
        self.rightTextField.font  = [UIFont systemFontOfSize:13.0];
        if ([self.textLabel.text isEqualToString:@"手机"]) {
                self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        self.accessoryView = self.rightTextField;
    }
    else{
        // 右边没有东西
        [self.detailTextLabel setTextColor:[UIColor darkGrayColor]];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    DebugMethod();
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(editCell:textFieldValueChangedWithMessage:)]) {
            [self.delegate editCell:self textFieldValueChangedWithMessage:@{@"key":self.item.title,@"values":textField.text}];
        }
    }
    
}



@end
