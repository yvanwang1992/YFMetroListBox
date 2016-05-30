# YFMetroListBox
Customer TableView IndexView just like Windows Phone.


[博客园记录: 【IOS】模仿windowsphone列表索引的控件YFRollingLabel](http://www.cnblogs.com/yffswyf/p/5541400.html) 

##Effection: 

Alphabet 
<p/>
 ![AllAlphabet](https://github.com/yvanwang1992/YFMetroListBox/blob/master/screenshots/AllAlphabet.gif)

HeaderView Label Name
<p/>
 ![GroupName](https://github.com/yvanwang1992/YFMetroListBox/blob/master/screenshots/GroupName.gif)
 
 
# How To Use It?

####1.#import "YFMetroListBox.h"

####2.Initialization:<p/>
	//Use just like normal UITableView; 
  	YFMetroListBox *metroListBox = [[YFMetroListBox alloc] initWithFrame:frame style:style];
	//or using like this (default style is UITableViewStylePlain)
	YFMetroListBox *metroListBox = [[YFMetroListBox alloc] initWithFrame:frame];

####3.Property:<p/>
	YFMetroListBoxType metroListBoxType.
    	set YFMetroListBoxTypeAllAlphabet: just like first picture above;
    	set YFMetroListBoxTypeGroupName  : just like second picture above;


  	CGSize itemSize                 //Each Item Size
	CGSize interSize                //Contains InternalWidth and InternalHeight
	UIColor *itemBackgroundColor	//Item Background Color
    


####5.protocol:<p/>
@protocol YFMetroListBoxDelegate <NSObject><p/>
@required<p/>
// return list of section titles to display in index view
- (NSArray<NSString *> *)sectionIndexTitlesForYFMetroListBox:(YFMetroListBox *)metroListBox;<p/>
@end

    
    metroListBox.listBoxDelegate = self;

####5.notice:<p/>
Please make sure that the HeaderView is Visible.<p/>
You can set HeaderView using either tableView:titleForHeaderInSection:  or<p/>
    tableView:viewForHeaderInSection: in UIScrollViewDelegate.<p/>
And set HeaderView's Height using tableView:heightForHeaderInSection or property sectionHeaderHeight;


