//
//  FDCell.m
//  FDTemplateLayoutCell的简单实用
//
//  Created by zhangxu on 16/2/14.
//  Copyright © 2016年 zhangxu. All rights reserved.
//

#import "FDCell.h"

@interface FDCell ()
@property (nonatomic,strong) UIImageView *coverIcon;// 图片
@property (nonatomic,strong) UILabel *nameLabel; // 名称
@property (nonatomic,strong) UILabel *consumption_per_person; // 人均
@property (nonatomic,strong) UIImageView *addressIcon; // 地址图标
@property (nonatomic,strong) UILabel *address; // 地址

@end

@implementation FDCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 添加图片
        self.coverIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_coverIcon];
        
        
        // 添加名称
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        
        // 添加人均
        self.consumption_per_person = [[UILabel alloc] init];
        self.consumption_per_person.textAlignment = NSTextAlignmentRight;
        self.consumption_per_person.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_consumption_per_person];
        
        
        
        // 添加地址图标
        self.addressIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:_addressIcon];
        
        
        // 添加地址
        self.address = [[UILabel alloc] init];
        self.address.numberOfLines = 0;
        self.address.font = [UIFont systemFontOfSize:15];
        self.address.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_address];
        
        
        
        // 给图片添加约束
        __weak typeof(self) weakSelf = self;
        CGFloat padding = 10;
        [self.coverIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.contentView.left).offset(padding);
            make.top.equalTo(weakSelf.contentView.top).offset(padding);
            make.right.equalTo(weakSelf.contentView.right).offset(-padding);
            make.bottom.equalTo(weakSelf.nameLabel.top).offset(-padding);
            
        }];
        
        
        // 给名称添加约束
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.contentView.left).offset(padding);
            make.top.equalTo(weakSelf.coverIcon.bottom).offset(padding);
            make.right.equalTo(weakSelf.contentView.right).offset(-padding);
            make.bottom.equalTo(weakSelf.address.top).offset(-padding);
        }];
        
        
        // 给人均添加约束
        [self.consumption_per_person mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.greaterThanOrEqualTo(weakSelf.contentView.left).offset(300);
            make.top.equalTo(weakSelf.coverIcon.bottom).offset(padding);
            make.right.equalTo(weakSelf.contentView.right).offset(-padding);
            make.bottom.equalTo(weakSelf.address.top).offset(-padding);
        }];
        
        // 给地址图标添加约束
        [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.contentView.left).offset(padding);
            make.top.equalTo(weakSelf.nameLabel.bottom).offset(padding + 5);
            make.top.equalTo(weakSelf.address.top);
            make.width.offset(padding * 2);
            make.height.offset(padding * 2);
            make.right.equalTo(weakSelf.address.left).offset(-padding/2);
        }];
        
        
        // 给地址添加约束
        [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.addressIcon.right).offset(padding/2);
            make.top.equalTo(weakSelf.nameLabel.bottom).offset(padding);
            make.right.lessThanOrEqualTo(weakSelf.contentView.right).offset(-padding);
            make.bottom.equalTo(weakSelf.contentView.bottom).offset(-padding * 2);
        }];
        
    }
    return self;
}


- (void)setModel:(FDModel *)model{
    _model = model;
    [self.coverIcon sd_setImageWithURL:[NSURL URLWithString:model.cover[@"url"]]];
    self.consumption_per_person.text = [NSString stringWithFormat:@"人均：￥%@",model.consumption_per_person];
    self.nameLabel.text = model.name;
    self.addressIcon.image = [UIImage imageNamed:@"iconfont-dingwei"];
    self.address.text = model.address;

}


- (CGSize)sizeThatFits:(CGSize)size{
    
    CGFloat totalHeight = 0;
    totalHeight += kScreenWidth/604 * 260;
    totalHeight += [self.nameLabel sizeThatFits:size].height;
    totalHeight += [self.address sizeThatFits:size].height;
    totalHeight += 30;
    return CGSizeMake(size.width, totalHeight);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
