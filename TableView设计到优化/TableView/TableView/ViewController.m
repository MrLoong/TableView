//
//  ViewController.m
//  TableView
//
//  Created by LastDay on 16/3/13.
//  Copyright © 2016年 LastDays. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSDictionary *myDictonary;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *oneArray = @[@"LastDays1",@"LastDays2",@"LastDays3"];
    NSArray *twoArray = @[@"白菜1",@"白菜2",@"白菜3"];
    NSArray *threeArray = @[@"小猪1",@"小猪2",@"小猪3"];
    
    self.myDictonary = @{@"LastDays":oneArray,@"白菜":twoArray,@"小猪":threeArray};
    
    [self configureTbaleView];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  配置TableView基本属性
 */
-(void)configureTbaleView{
    //改变行线颜色
    _tableView.separatorColor = [UIColor blueColor];
    //设定Header的高度，
    _tableView.sectionHeaderHeight=100;
    //设定footer的高度，
    _tableView.sectionFooterHeight=100;
    //设定行高
    _tableView.rowHeight=100;
    //设定cell分行线的样式，默认为UITableViewCellSeparatorStyleSingleLine
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    //设定cell分行线颜色
    [_tableView setSeparatorColor:[UIColor redColor]];
    //编辑tableView
    _tableView.editing=NO;
    
}

/**
 *  指定多少个分区
 *
 *  @param tableView tableView
 *
 *  @return myDictonary键值个数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[_myDictonary allKeys] count];
}
/**
 *  指定每个分区中有多少行
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 返回当前section所需行数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.myDictonary objectForKey:[[self.myDictonary allKeys]objectAtIndex:section]] count];;
}

/**
 *  section底部标题高度（实现这个代理方法后前面 sectionHeaderHeight 设定的高度无效）
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 底部标题所需高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

/**
 *  每个section头部标题高度（实现这个代理方法后前面 sectionFooterHeight 设定的高度无效）
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 头部标题所需高度
 */
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

/**
 *  每个section头部标题
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 头部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.myDictonary allKeys] objectAtIndex:section];
}

/**
 *  每个人section底部标题
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 底部标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"底部标题";
}

/**
 *  自定义section头部View，想测试可以去掉注释
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 自定义UIView
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    imageView.image = [UIImage imageNamed:@"author.png"];
//    return imageView;
    return nil;
}

/**
 *  自定义底部View
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 自定义UIView
 */
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

/**
 *  改变行高，需要注意，实现这个代理方法后， rowHeight 设定的高度无效无效
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return 返回行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    return cell.frame.size.height;
}

/**
 *  绘制Cell
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return Cell
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        /**
         *  设定附加视图
         *  UITableViewCellAccessoryNone,                    没有标示
         *  UITableViewCellAccessoryDisclosureIndicator,     下一层标示
         *  UITableViewCellAccessoryDetailDisclosureButton,  详情button
         *  UITableViewCellAccessoryCheckmark                勾选标记
         */
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
        /**
         *  选定cell时改变颜色
         *  cell.selectionStyle=UITableViewCellSelectionStyleBlue;   选中时蓝色效果
         *  cell.selectionStyle=UITableViewCellSelectionStyleNone;   选中时没有颜色效果
         *  cell.selectionStyle=UITableViewCellSelectionStyleGray;   选中时灰色效果
         */
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;

    }
    //[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.imageView.image=[UIImage imageNamed:@"author.png"];//未选cell时的图片
    cell.imageView.highlightedImage=[UIImage imageNamed:@"logo.png"];//选中cell后的图片
    
    cell.textLabel.text = [[self.myDictonary objectForKey:[[self.myDictonary allKeys]objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    
    return cell;
}

/**
 *  行缩进，按照阶梯状下移
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return row
 */
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    return row;
}

/**
 *  行将显示的时候调用，预加载行
 *
 *  @param tableView tableView
 *  @param cell      cell
 *  @param indexPath indexPath
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"将要显示的行是\n cell=%@  \n indexpath=%@",cell,indexPath);
}


/**
 *  选中Cell响应
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    //得到当前选中的cell
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"cell=%@",cell);
}

/**
 *  didSelectRowAtIndexPath操作之前执行，这里我们设置第二行不可选
 *
 *  @param tableView tableView
 *  @param cell      选中的cell
 *  @param indexPath indexPath
 */
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    if (row == 1) {
        return nil;
    }
    return indexPath;
}

/**
 *  cell右边按钮格式为UITableViewCellAccessoryDetailDisclosureButton时，点击按扭时调用的方法
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 */
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"当前点击的详情button \n indexpath=%@",indexPath);
}

/**
 *  右侧添加索引表
 *
 *  @param tableView tableView
 *
 *  @return 索引NSArray
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self.myDictonary allKeys];
}
/**
 *  侧滑Cell是否出现删除
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return BOOl
 */
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return YES;
}

/**
 *  设定横向滑动时是否出现删除按扭
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return UITableViewCellEditingStyle
 */
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    return UITableViewCellEditingStyleDelete;
}

/**
 *  自定义delete按钮
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return NSString
 */
- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除这行";
    
}
/**
 *  开始移动row时执行
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return NSString
 */
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    NSLog(@"sourceIndexPath=%@",sourceIndexPath);
    NSLog(@"sourceIndexPath=%@",destinationIndexPath);
}
/**
 *  滑动可以编辑时执行
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return NSString
 */
-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"willBeginEditingRowAtIndexPath");
}
/**
 *  将取消选中时执行, 也就是上次先中的行
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return NSString
 */
-(NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"上次选中的行是  \n indexpath=%@",indexPath);
    return indexPath;
}

/**
 *  让行可以移动
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return NSString
 */
-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
/**
 *  移动row时执行
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return NSString
 */
-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSLog(@"targetIndexPathForMoveFromRowAtIndexPath");
    //用于限制只在当前section下面才可以移动
    if(sourceIndexPath.section != proposedDestinationIndexPath.section){
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

@end
