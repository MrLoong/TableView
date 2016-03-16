# UITableView 从设计到到优化

* LastDays，这是我的[Blog](lastdays.cn)，我在这里分享我的学习，
* 我的[微博](http://weibo.com/p/1005055848341536/home?from=page_100505&mod=TAB&is_all=1#place)我在这里分享我的生活，欢迎交流


经常使用UITableView，在一些应用，发现他们写的TableView非常的流畅漂亮，因此自己准备系统的学习一下TableView，最后进行一下总结


## UITableView优化技巧

UITableView的优化是UITableView的难点，流畅的运行，打造出类是朋友圈的功能，优化就是我们需要考虑的东西了。

### UITableViewCell的重用

**用过UITableView的人都知道，其实它最关键的地方就是UITableViewCell，重用思想我理解的就是，Cell滑出屏幕大小的时候，将它放到一个集合中，当要显示某一位置的时候，我们将从我们之前的集合中取出，如果集合中没有，那么我们就重新创建一个，很简单，这么做的结果就是减小了内存的开销。**

### 回调分析

``` bash
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

```
UITableView两个回调方法tableView:cellForRowAtIndexPath:和tableView:heightForRowAtIndexPath:他们的调用顺序我开始的时候认为先调，用的tableView:cellForRowAtIndexPath:在调用tableView:cellForRowAtIndexPath:先绘制控件，然后在设置布局，这是我们写控件的时候基本的思路，然而UITableView并没有那么做，而是先确定Cell的位置，在将Cell绘制在相应的位置上，就是说先调用tableView:heightForRowAtIndexPath:，在调用tableView:cellForRowAtIndexPath:

就像我们上面的例子，每个section要显示3个Cell，那么就是先调用三次tableView:heightForRowAtIndexPath:显示50个Cell时我们就先调用50次，然后在调用3次tableView:cellForRowAtIndexPath:。我们滚动屏幕时，每当Cell滚入屏幕，都会调用一次tableView:heightForRowAtIndexPath:、tableView:cellForRowAtIndexPath:方法。

基本上已经很清晰了，我们的优化主要也就是针对这两个回调展开。



### 简单优化
具体的优化思路就是让tableView:cellForRowAtIndexPath:方法只负责赋值，tableView:heightForRowAtIndexPath:方法只负责计算高度，不要出现代码重叠现象。根据这样的思路，其实我们可以在得到数据的时候就进行优化，计算出对应的布局，并且缓存起来，这样我们在tableView:heightForRowAtIndexPath:方法中直接返回高度，在这里又节省了计算的开销

``` bash
NSDictionary * frameDictionary = self. frameList[indexPath.row];
CGRect rect = [dict[@"frame"] CGRectValue];
return rect.frame.height;
``` 


###自定义Cell
以上的简单思路就是应对简单的布局而已，如果要是那种朋友圈图文混排的，还是需要自定义Cell的，重写drawRect,然后进行异步绘制，在这里找到一个简单的示例代码

``` bahs
//异步绘制
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect rect = [_data[@"frame"] CGRectValue];
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
	//整个内容的背景
        [[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1] set];
        CGContextFillRect(context, rect);
	//转发内容的背景
        if ([_data valueForKey:@"subData"]) {
            [[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1] set];
            CGRect subFrame = [_data[@"subData"][@"frame"] CGRectValue];
            CGContextFillRect(context, subFrame);
            [[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1] set];
            CGContextFillRect(context, CGRectMake(0, subFrame.origin.y, rect.size.width, .5));
        }
        
        {
	    //名字
            float leftX = SIZE_GAP_LEFT+SIZE_AVATAR+SIZE_GAP_BIG;
            float x = leftX;
            float y = (SIZE_AVATAR-(SIZE_FONT_NAME+SIZE_FONT_SUBTITLE+6))/2-2+SIZE_GAP_TOP+SIZE_GAP_SMALL-5;
            [_data[@"name"] drawInContext:context withPosition:CGPointMake(x, y) andFont:FontWithSize(SIZE_FONT_NAME)
                             andTextColor:[UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1]
                                andHeight:rect.size.height];
	    //时间+设备
            y += SIZE_FONT_NAME+5;
            float fromX = leftX;
            float size = [UIScreen screenWidth]-leftX;
            NSString *from = [NSString stringWithFormat:@"%@  %@", _data[@"time"], _data[@"from"]];
            [from drawInContext:context withPosition:CGPointMake(fromX, y) andFont:FontWithSize(SIZE_FONT_SUBTITLE)
                   andTextColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1]
                      andHeight:rect.size.height andWidth:size];
        }
	//将绘制的内容以图片的形式返回，并调主线程显示
	UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (flag==drawColorFlag) {
                postBGView.frame = rect;
                postBGView.image = nil;
                postBGView.image = temp;
            }
	}
	//内容如果是图文混排，就添加View，用CoreText绘制
	[self drawText];
}}

```


### 动态按需加载

按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。节省开销

一段示例代码

``` bahs
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row)>skipCount) {
        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y, self.width, self.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y<0) {
            NSIndexPath *indexPath = [temp lastObject];
            if (indexPath.row+3<datas.count) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row>3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        [needLoadArr addObjectsFromArray:arr];
    }
}

```

## 总结

设计和优化简单的流程就是这些，我们总结下

* 流畅的优化主要是先计算好高度布局，然后让tableView heightForRowAtIndexPath:直接返回高度节省内存开销。
* 异步加载，按需加载Cell
* 在TableView中我们经常会结合网络请求，大量加载图片，SDWebImage异步图片加载非常强大，善于利用。

除了上面最主要的三个方面外，还有很多几乎大伙都很熟知的优化点：

上面的三点是一个核心，还有一些常识

* Cell内容来自web，尽量使用异步加载，缓存我们的请求结果，减少网络请求
* 减少图层
* 使用reuseIdentifier来重用Cells
如果Cell内现实的内容来自web，使用异步加载，缓存请求结果
减少subviews的数量
* 在heightForRowAtIndexPath:中尽量不使用cellForRowAtIndexPath:，如果你需要用到它，只用一次然后缓存结果


sunnyxx大神写过的一篇文章[优化UITableViewCell高度计算的那些事](http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/) 非常值得仔细看看


