//
//  NRArealocationView.m
//  eLongRoom
//
//  Created by Root on 16/5/18.
//  Copyright © 2016年 Root. All rights reserved.
//

#import "RTArealocationView.h"

#define NUM 3       // 菜单的层级

@interface RTArealocationView ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger        selectedIndex[NUM];  // 每层选中的索引index
    CGFloat          leftWidth;           // 左边栏宽度
    NSMutableArray<UITableView*>   *tableViewArr;       // 存放每层的tableView的数组
    UIView           *backgroundView;     // 背景view
    NSInteger        selectedRow;         // 选中的行
    UIImageView      *selIcon;            // 选中的icon
    UITableViewCell  *selCell;            // 选中的cell
    UITableView* lastTableView;
}

@end

@implementation RTArealocationView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

#pragma mark - init
- (void)setupUI {
    [self setupSubViews];
    
    // 初始化 tableView
    for (int i=0; i<NUM; i++) {
        
        selectedIndex[i] = -1;
        
        UITableView *locationView = [[UITableView alloc] init];
        locationView.dataSource = self;
        locationView.delegate = self;
        locationView.rowHeight = 48;
        locationView.frame = self.bounds;
        locationView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        //locationView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableViewArr addObject:locationView];
    }
    backgroundView = [[UIView alloc] init];
    [backgroundView addSubview:tableViewArr[0]];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - setupSubViews
- (void)setupSubViews {

    selIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nr_selected"]];
    selectedRow = 0;
    tableViewArr = [NSMutableArray array];
    leftWidth = 96;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    __block NSInteger count;
    
    [tableViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj == tableView) {
            
            if ([self.delegate respondsToSelector:@selector(arealocationView:countForClassAtLevel:index:selectedIndex:)]) {
                
                count = [self.delegate arealocationView:self countForClassAtLevel:idx index:selectedRow selectedIndex:selectedIndex];
                *stop = YES;
            }
        }
    }];
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"location_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    else{
        
    }
    cell.textLabel.textColor = [UIColor grayColor];
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj == tableView) {
            
            if ([self.delegate respondsToSelector:@selector(arealocationView:titleForClass:index:selectedIndex:)]) {
                
                cell.textLabel.text = [self.delegate arealocationView:self titleForClass:idx index:indexPath.row selectedIndex:selectedIndex];
                
                cell.textLabel.numberOfLines = 0;
                
                BOOL selected = [self.delegate isSelectedLocationInAreaLocationView:self atLevel:idx selectedIndex:selectedIndex index:indexPath.row];
                if (selected) {
                    cell.textLabel.textColor = [UIColor orangeColor];
                }
                else{
                    cell.textLabel.textColor = [UIColor grayColor];
                }
                
                if (idx == 0) {
                    
                    cell.contentView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
                    
                }
            }
        }
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    if (selCell!=cell) {

        //[selIcon removeFromSuperview];
        //selCell.textLabel.textColor = [UIColor grayColor];
        selCell = cell;
        
    }
    

    
    NSMutableArray* selectedIndexArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (int i=0; i<tableViewArr.count; i++) {
        
        UITableView *tempTableView = tableViewArr[i];
//        NSInteger selectRow =  tempTableView.indexPathForSelectedRow.row;
//        [selectedIndexArray addObject:@(selectRow)];
        // 添加下一级tableView
        NSInteger nextTableRowsCount = -1;
        if (tempTableView == tableView && i != tableViewArr.count - 1) {
            
            selectedRow = indexPath.row;
            
            selectedIndex[i] = indexPath.row;
            [tableViewArr[i+1] reloadData];
            
            nextTableRowsCount = [tableViewArr[i+1] numberOfRowsInSection:0];
            
            if (![tableViewArr[i+1] superview] && nextTableRowsCount > 0) {
                
                
                [backgroundView addSubview:tableViewArr[i+1]];
                lastTableView = tableViewArr[i+1];
                

            }            // 移除多余的tableView
            for (int j=i; j<tableViewArr.count-2; j++) {
                
                if ([tableViewArr[j+2] superview]) {
                    
                    [tableViewArr[j+2] removeFromSuperview];
                    lastTableView = tableViewArr[j+1] ;
                }
            }
            
            [self adjustTableViews];
        
            break;
        }
        else{
            
        }
        


    }
    
    if (lastTableView == tableView ) {
        
        [self saveSelectedIndex];
        
        // 添加选中icon
        //CGPoint center = CGPointMake(cell.frame.size.width * 0.9, cell.frame.size.height * 0.5);
        
        //selIcon.center = center;
        
        //[cell.contentView addSubview:selIcon];
        
        // 改变选中颜色
       // cell.textLabel.textColor = [UIColor orangeColor];
        
        //[self dismissArealocationView];
        
        // 选中后执行方法
        NSInteger level = [tableViewArr indexOfObject:tableView];
        if ([self.delegate respondsToSelector:@selector(arealocationView:atLevel:finishChooseLocationAtIndexs:)]) {
            
            [self.delegate arealocationView:self atLevel:level finishChooseLocationAtIndexs:selectedIndex];
            
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}


#pragma mark - 保存tableView的选中项
- (void)saveSelectedIndex {
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        selectedIndex[idx] = tableView.superview ? tableView.indexPathForSelectedRow.row : -1;
    }];
}

#pragma mark - 加载保存的tableView的选中项
- (void)loadSelectedIndex {
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:
                                         selectedIndex[idx]
                                                           inSection:0]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
        
        // 将选中tableView添加到backgroundView上
        if ((selectedIndex[idx] !=-1 && !tableView.superview) || !idx) {
            
            [backgroundView addSubview:tableView];
        }
    }];
}

#pragma mark - showArealocationView
- (void)showArealocationInView:(UIView *)view {
    
    backgroundView.frame = self.bounds;
    // 添加backgroundView
    if(!backgroundView.superview) {
        [self addSubview:backgroundView];
    }
    
    [self loadSelectedIndex];
    [self adjustTableViews];
    [view addSubview:self];
    
    [self tableView:tableViewArr[0] didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark - dismissArealocationView
- (void)dismissArealocationView {
    
    if(self.superview) {
        [UIView animateWithDuration:.5f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            [backgroundView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - 调整表视图的位置和大小
- (void)adjustTableViews {
    
    __block NSInteger showTableCount = 0;  // 显示的tableView数量
    
    [tableViewArr enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL *stop) {
        
        if(tableView.superview) {
            
            showTableCount ++;
        }
    }];
    
    // 调整tableView的宽度
    for(int i=0; i<showTableCount;i++) {
        UITableView *tableView = [tableViewArr objectAtIndex:i];
        CGRect frame = tableView.frame;
        
        if (i==0) {
            tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
            
            frame.size.width = leftWidth;
            frame.origin.x = 0;
          
        }else {
            
            CGFloat rightWidth = ((kScreenWidth - leftWidth) / (showTableCount - 1))-1;
            frame.origin.x = leftWidth + rightWidth * (i-1)+i;
            frame.size.width = rightWidth;
        }
        
        frame.size.height = self.frame.size.height;
        tableView.frame = frame;
    }
}

#pragma mark - 设置选中的cell
- (void)selectRowWithSelectedIndex:(NSInteger *)selectIndex {
    
    for (int i=0; i<NUM; i++) {
        
        UITableView *tableView = tableViewArr[i];
        
        if (selectIndex[i]!=-1) {
            
            [self tableView:tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex[i] inSection:0]];
        }
  
    }
}

@end

