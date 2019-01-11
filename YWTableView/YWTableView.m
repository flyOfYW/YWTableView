//
//  YWTableView.m
//  YWTableViewExamples
//
//  Created by yaowei on 2019/1/10.
//  Copyright © 2019 yaowei. All rights reserved.
//

#import "YWTableView.h"
#import "YWTableViewSection.h"

@implementation YWTableView{
    
    BOOL _needsReload;

    NSMutableDictionary *_cachedCells;
    NSMutableSet *_reusableCells;
    NSMutableArray *_sections;
    
    NSMutableDictionary *_leftCachedCells;
    NSMutableSet *_leftReusableCells;
    
    NSMutableDictionary *_rightCachedCells;
    NSMutableSet *_rightReusableCells;
    
    
    struct {
        unsigned heightForRowAtIndexPath : 1;
        unsigned heightForHeaderInSection : 1;
        unsigned heightForFooterInSection : 1;
        
        unsigned widthForLeftInSection : 1;
        unsigned widthForRightInSection : 1;

        unsigned viewForHeaderInSection : 1;
        unsigned viewForFooterInSection : 1;
        
        unsigned didSelectRowAtIndexPath : 1;
        unsigned didSelectLeftViewAtIndexPath : 1;
        unsigned didSelectRightViewAtIndexPath : 1;
        
    } _delegateHas;
    
    struct {
        unsigned numberOfSectionsInTableView : 1;
        unsigned leftCellOfSectionsInTableView : 1;
        unsigned rightCellOfSectionsInTableView : 1;

    } _dataSourceHas;
}
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame style:YWTableViewStyleDefalut];
}

- (instancetype)initWithFrame:(CGRect)frame style:(YWTableViewStyle)theStyle{
    if ((self=[super initWithFrame:frame])) {
        _style = theStyle;
        _cachedCells = [[NSMutableDictionary alloc] init];
        _sections = [[NSMutableArray alloc] init];
        _reusableCells = [[NSMutableSet alloc] init];
        
        _leftCachedCells = [[NSMutableDictionary alloc] init];
        _leftReusableCells = [[NSMutableSet alloc] init];
        
        _rightCachedCells = [[NSMutableDictionary alloc] init];
        _rightReusableCells = [[NSMutableSet alloc] init];
        
        self.separatorColor = [UIColor colorWithRed:.88f green:.88f blue:.88f alpha:1];
        self.separatorStyle = YWTableViewCellSeparatorStyleSingleLine;
        self.sectionHeaderHeight = self.sectionFooterHeight = 0;
        self.alwaysBounceVertical = YES;
        
        if (_style == UITableViewStylePlain) {
            self.backgroundColor = [UIColor whiteColor];
        }
        [self yw_setNeedsReload];
    }
    return self;
}
- (void)setDelegate:(id<YWTableViewDelegate>)newDelegate{
    [super setDelegate:newDelegate];
    
    _delegateHas.heightForRowAtIndexPath = [newDelegate respondsToSelector:@selector(yw_tableView:heightForRowAtIndexPath:)];
    _delegateHas.heightForHeaderInSection = [newDelegate respondsToSelector:@selector(yw_tableView:heightForHeaderInSection:)];
    _delegateHas.heightForFooterInSection = [newDelegate respondsToSelector:@selector(yw_tableView:heightForFooterInSection:)];
    _delegateHas.viewForHeaderInSection = [newDelegate respondsToSelector:@selector(yw_tableView:viewForHeaderInSection:)];
    _delegateHas.viewForFooterInSection = [newDelegate respondsToSelector:@selector(yw_tableView:viewForFooterInSection:)];
    _delegateHas.didSelectRowAtIndexPath = [newDelegate respondsToSelector:@selector(yw_tableView:didSelectRowAtIndexPath:)];
    _delegateHas.didSelectLeftViewAtIndexPath = [newDelegate respondsToSelector:@selector(yw_tableView:didSelectLeftViewAtIndexPath:)];
    _delegateHas.didSelectRightViewAtIndexPath = [newDelegate respondsToSelector:@selector(yw_tableView:didSelectRightViewAtIndexPath:)];
    _delegateHas.widthForLeftInSection = [newDelegate respondsToSelector:@selector(yw_tableView:widthForLeftInSection:)];
    _delegateHas.widthForRightInSection = [newDelegate respondsToSelector:@selector(yw_tableView:widthForRightInSection:)];
}
- (void)setDataSource:(id<YWTableViewDataSource>)newDataSource{
    
    _dataSource = newDataSource;
    _dataSourceHas.numberOfSectionsInTableView = [_dataSource respondsToSelector:@selector(yw_numberOfSectionsInTableView:)];
    _dataSourceHas.leftCellOfSectionsInTableView = [_dataSource respondsToSelector:@selector(yw_tableView:leftCellForRowAtIndexPath:)];
    _dataSourceHas.rightCellOfSectionsInTableView = [_dataSource respondsToSelector:@selector(yw_tableView:rightCellForRowAtIndexPath:)];

    [self yw_setNeedsReload];
}

- (void)yw_setNeedsReload{
    _needsReload = YES;
    [self setNeedsLayout];
}
- (void)yw_reloadDataIfNeeded{
    if (_needsReload) {
        [self reloadData];
    }
}
- (void)reloadData{
    [self yw_updateSectionsCache];
    [self yw_setContentSize];
    _needsReload = NO;
}
- (void)yw_updateSectionsCache{
    
    for (YWTableViewSection *previousSectionRecord in _sections) {
        [previousSectionRecord.headerView removeFromSuperview];
        [previousSectionRecord.footerView removeFromSuperview];
    }
    
    [_sections removeAllObjects];
    
    if (_dataSource) {
        const CGFloat defaultRowHeight  = _rowHeight ?: 40;
        const CGFloat defaultLeftWidth  = _leftWidth ?: 100;
        const CGFloat defaultRightWidth = _rightWidth?: 100;

        const NSInteger numberOfSections = [self numberOfSections];
        
        for (NSInteger section=0; section<numberOfSections; section++) {
            const NSInteger numberOfRowsInSection = [self numberOfRowsInSection:section];
            YWTableViewSection *sectionRecord = [[YWTableViewSection alloc] init];
            
            sectionRecord.headerHeight = _delegateHas.heightForHeaderInSection? [self.delegate yw_tableView:self heightForHeaderInSection:section] : _sectionHeaderHeight;
            sectionRecord.footerHeight = _delegateHas.heightForFooterInSection ? [self.delegate yw_tableView:self heightForFooterInSection:section] : _sectionFooterHeight;
            
            sectionRecord.leftWidth = _delegateHas.widthForLeftInSection ? [self.delegate yw_tableView:self widthForLeftInSection:section] : defaultLeftWidth;
            sectionRecord.rightWidth = _delegateHas.widthForRightInSection ? [self.delegate yw_tableView:self widthForRightInSection:section] : defaultRightWidth;

            
            sectionRecord.headerView = (sectionRecord.headerHeight > 0 && _delegateHas.viewForHeaderInSection)? [self.delegate yw_tableView:self viewForHeaderInSection:section] : nil;
            sectionRecord.footerView = (sectionRecord.footerHeight > 0 && _delegateHas.viewForFooterInSection)? [self.delegate yw_tableView:self viewForFooterInSection:section] : nil;
            
            if (sectionRecord.headerView) {
                [self addSubview:sectionRecord.headerView];
            } else {
                sectionRecord.headerHeight = 0;
            }
            if (sectionRecord.footerView) {
                [self addSubview:sectionRecord.footerView];
            } else {
                sectionRecord.footerHeight = 0;
            }
            
            CGFloat *rowHeights = malloc(numberOfRowsInSection * sizeof(CGFloat));
            CGFloat totalRowsHeight = 0;
            
            for (NSInteger row = 0; row < numberOfRowsInSection; row++) {
                const CGFloat rowHeight = _delegateHas.heightForRowAtIndexPath ? [self.delegate yw_tableView:self heightForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]] : defaultRowHeight;
                rowHeights[row] = rowHeight;
                totalRowsHeight += rowHeight;
            }
            sectionRecord.rowsHeight = totalRowsHeight;
            [sectionRecord setNumberOfRows:numberOfRowsInSection withHeights:rowHeights];
            free(rowHeights);
            [_sections addObject:sectionRecord];
        }
    }
}
- (void)yw_updateSectionsCacheIfNeeded{
    if ([_sections count] == 0) {
        [self yw_updateSectionsCache];
    }
}
- (void)yw_setContentSize{
    [self yw_updateSectionsCacheIfNeeded];
    CGFloat height = _tableHeaderView? _tableHeaderView.frame.size.height : 0;
    for (YWTableViewSection *section in _sections) {
        height += [section sectionHeight];
    }
    if (_tableFooterView) {
        height += _tableFooterView.frame.size.height;
    }
    self.contentSize = CGSizeMake(0,height);
}
- (void)yw_layoutTableView{
    
    const CGSize boundsSize = self.bounds.size;
    const CGFloat contentOffset = self.contentOffset.y;
    
    const CGRect visibleBounds = CGRectMake(0,contentOffset,boundsSize.width,boundsSize.height);
    CGFloat tableHeight = 0;
    
    if (_tableHeaderView) {
        CGRect tableHeaderFrame = _tableHeaderView.frame;
        tableHeaderFrame.origin = CGPointZero;
        tableHeaderFrame.size.width = boundsSize.width;
        _tableHeaderView.frame = tableHeaderFrame;
        tableHeight += tableHeaderFrame.size.height;
    }
    
    NSMutableDictionary *availableCells = [_cachedCells mutableCopy];
    const NSInteger numberOfSections = [_sections count];
    [_cachedCells removeAllObjects];
    
    NSMutableDictionary *leftAvailableCells = [_leftCachedCells mutableCopy];
    [_leftCachedCells removeAllObjects];
    
    NSMutableDictionary *rightAvailableCells = [_rightCachedCells mutableCopy];
    [_rightCachedCells removeAllObjects];
    
    
    
    for (NSInteger section = 0; section < numberOfSections; section ++) {
        CGRect sectionRect = [self yw_rectForSection:section];
        tableHeight += sectionRect.size.height;
        if (CGRectIntersectsRect(sectionRect, visibleBounds)) {
            const CGRect headerRect = [self yw_rectForHeaderInSection:section];
            const CGRect footerRect = [self yw_rectForFooterInSection:section];
            YWTableViewSection *sectionRecord = [_sections objectAtIndex:section];
            const NSInteger numberOfRows = sectionRecord.numberOfRows;
            if (sectionRecord.headerView) {
                sectionRecord.headerView.frame = headerRect;
            }
            if (sectionRecord.footerView) {
                sectionRecord.footerView.frame = footerRect;
            }

            //----leftView start
            CGFloat leftPadding = 0;
            if (_dataSourceHas.leftCellOfSectionsInTableView) {
                NSIndexPath *leftIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                YWTableViewLeftCell *leftView = [leftAvailableCells objectForKey:leftIndexPath];
                leftView = leftView ? leftView : [self.dataSource yw_tableView:self leftCellForRowAtIndexPath:leftIndexPath];
                if (leftView) {
                    leftPadding = sectionRecord.leftWidth;
                    CGRect leftRect = CGRectMake(0, CGRectGetMaxY(headerRect),
                                                 leftPadding, sectionRecord.rowsHeight);
                    [_leftCachedCells setObject:leftView forKey:leftIndexPath];
                    [leftAvailableCells removeObjectForKey:leftIndexPath];
                    leftView.frame = leftRect;
                    [self addSubview:leftView];
                }
            }
            //---end
            
            CGFloat cellWidth = boundsSize.width - leftPadding;
            
            //----rightView start
            CGFloat rightPadding = 0;
            YWTableViewRightCell *rightView = nil;
            if (_dataSourceHas.rightCellOfSectionsInTableView) {
                NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                 [rightAvailableCells objectForKey:rightIndexPath];
                 rightView = rightView ? rightView : [self.dataSource yw_tableView:self rightCellForRowAtIndexPath:rightIndexPath];
                if (rightView) {
                    rightPadding = sectionRecord.rightWidth;
                    cellWidth = cellWidth - rightPadding;
                    
                    CGRect rightRect = CGRectMake(0, CGRectGetMaxY(headerRect),
                                                  rightPadding, sectionRecord.rowsHeight);
                    
                    if (leftPadding == 0) {
                        rightRect.origin.x = cellWidth;
                    }else{
                        rightRect.origin.x = cellWidth + leftPadding;
                    }
                    [_rightCachedCells setObject:rightView forKey:rightIndexPath];
                    [rightAvailableCells removeObjectForKey:rightIndexPath];
                    rightView.frame = rightRect;
                    [self addSubview:rightView];
                }
            }

            //---end
            
            for (NSInteger row = 0; row < numberOfRows; row ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                CGRect rowRect = [self yw_rectForRowAtIndexPath:indexPath];
                YWTableViewCell *ableCell = [availableCells objectForKey:indexPath];
                if (CGRectIntersectsRect(rowRect,visibleBounds) && rowRect.size.height > 0) {
                    YWTableViewCell *cell = ableCell ? ableCell : [self.dataSource yw_tableView:self cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        [_cachedCells setObject:cell forKey:indexPath];
                        [availableCells removeObjectForKey:indexPath];
                        rowRect.origin.x = leftPadding;
                        rowRect.size.width = cellWidth;
//                        rowRect.size.width = boundsSize.width - leftPadding - rightPadding;
                        cell.frame = rowRect;
                        [cell setLineView:self.separatorStyle theColor:self.separatorColor];
                        [self addSubview:cell];
                    }
                }
                //                else{
                //                    if (ableCell) {
                //                        [ableCell removeFromSuperview];
                //                        [_reusableCells addObject:ableCell];
                //                    }
                //                }
            }
            
        }
    }
    
    for (YWTableViewCell *cell in [availableCells allValues]) {
        if (cell.reuseIdentifier) {
            [_reusableCells addObject:cell];
        } else {
            [cell removeFromSuperview];
        }
    }
    
    NSArray* allCachedCells = [_cachedCells allValues];
    for (YWTableViewCell *cell in _reusableCells) {
        if (CGRectIntersectsRect(cell.frame,visibleBounds) && ![allCachedCells containsObject: cell]) {
            [cell removeFromSuperview];
        }
    }
    
    //left cell
    for (YWTableViewLeftCell *cell in [leftAvailableCells allValues]) {
        if (cell.reuseIdentifier) {
            [_leftReusableCells addObject:cell];
        } else {
            [cell removeFromSuperview];
        }
    }
    NSArray* allCachedCells1 = [_leftCachedCells allValues];
    for (YWTableViewLeftCell *cell in _leftReusableCells) {
        if (CGRectIntersectsRect(cell.frame,visibleBounds) && ![allCachedCells1 containsObject: cell]) {
            [cell removeFromSuperview];
        }
    }
    //right cell
    for (YWTableViewRightCell *cell in [rightAvailableCells allValues]) {
        if (cell.reuseIdentifier) {
            [_rightReusableCells addObject:cell];
        } else {
            [cell removeFromSuperview];
        }
    }
    NSArray* allCachedCells2 = [_rightCachedCells allValues];
    for (YWTableViewRightCell *cell in _rightReusableCells) {
        if (CGRectIntersectsRect(cell.frame,visibleBounds) && ![allCachedCells2 containsObject: cell]) {
            [cell removeFromSuperview];
        }
    }
    
    
    
    if (_tableFooterView) {
        CGRect tableFooterFrame = _tableFooterView.frame;
        tableFooterFrame.origin = CGPointMake(0,tableHeight);
        tableFooterFrame.size.width = boundsSize.width;
        _tableFooterView.frame = tableFooterFrame;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    const CGPoint location = [touch locationInView:self];
   NSIndexPath *seletedRow = [self yw_indexPathForRowAtPoint:location];
    
    if (seletedRow) {
        [self yw_setUserSelectedRowAtIndexPath:seletedRow contentView:touch.view];
        seletedRow = nil;
    }
}

- (void)yw_setUserSelectedRowAtIndexPath:(NSIndexPath *)rowToSelect contentView:(UIView *)contentView{

    if ([contentView isKindOfClass:[YWTableViewLeftCell class]]) {
        if (_delegateHas.didSelectLeftViewAtIndexPath) {
            [self.delegate yw_tableView:self didSelectLeftViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rowToSelect.section]];
        }
    }else if ([contentView isKindOfClass:[YWTableViewRightCell class]]){
        [self.delegate yw_tableView:self didSelectRightViewAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:rowToSelect.section]];
    }else{
        if (_delegateHas.didSelectRowAtIndexPath) {
            [self.delegate yw_tableView:self didSelectRowAtIndexPath:rowToSelect];
        }
    }
    
}

- (YWTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier{
    for (YWTableViewCell *cell in _reusableCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            YWTableViewCell *strongCell = cell;
            [_reusableCells removeObject:cell];
            [strongCell prepareForReuse];
            return strongCell;
        }
    }
    return nil;
}
- (YWTableViewLeftCell *)dequeueReusableCellWithIdentifierOnLeft:(NSString *)identifier{
    for (YWTableViewLeftCell *cell in _leftReusableCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            YWTableViewLeftCell *strongCell = cell;
            [_leftReusableCells removeObject:cell];
            [strongCell prepareForReuse];
            return strongCell;
        }
    }
    return nil;
}
- (YWTableViewRightCell *)dequeueReusableCellWithIdentifierOnRight:(NSString *)identifier{
    for (YWTableViewRightCell *cell in _rightReusableCells) {
        if ([cell.reuseIdentifier isEqualToString:identifier]) {
            YWTableViewRightCell *strongCell = cell;
            [_rightReusableCells removeObject:cell];
            [strongCell prepareForReuse];
            return strongCell;
        }
    }
    return nil;
}



- (NSInteger)numberOfSections
{
    if (_dataSourceHas.numberOfSectionsInTableView) {
        return [self.dataSource yw_numberOfSectionsInTableView:self];
    } else {
        return 1;
    }
}
- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource yw_tableView:self numberOfRowsInSection:section];
}

- (CGRect)yw_rectForSection:(NSInteger)section
{
    [self yw_updateSectionsCacheIfNeeded];
    return [self yw_CGRectFromVerticalOffset:[self yw_offsetForSection:section] height:[[_sections objectAtIndex:section] sectionHeight]];
}
- (CGRect)yw_CGRectFromVerticalOffset:(CGFloat)offset height:(CGFloat)height
{
    return CGRectMake(0,offset,self.bounds.size.width,height);
}
- (CGFloat)yw_offsetForSection:(NSInteger)index
{
    CGFloat offset = _tableHeaderView? _tableHeaderView.frame.size.height : 0;
    
    for (NSInteger s=0; s<index; s++) {
        offset += [[_sections objectAtIndex:s] sectionHeight];
    }
    
    return offset;
}
- (CGRect)yw_rectForHeaderInSection:(NSInteger)section
{
    [self yw_updateSectionsCacheIfNeeded];
    return [self yw_CGRectFromVerticalOffset:[self yw_offsetForSection:section] height:[[_sections objectAtIndex:section] headerHeight]];
}

- (CGRect)yw_rectForFooterInSection:(NSInteger)section
{
    [self yw_updateSectionsCacheIfNeeded];
    YWTableViewSection *sectionRecord = [_sections objectAtIndex:section];
    CGFloat offset = [self yw_offsetForSection:section];
    offset += sectionRecord.headerHeight;
    offset += sectionRecord.rowsHeight;
    return [self yw_CGRectFromVerticalOffset:offset height:sectionRecord.footerHeight];
}

- (CGRect)yw_rectForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self yw_updateSectionsCacheIfNeeded];
    
    if (indexPath && indexPath.section < [_sections count]) {
        YWTableViewSection *sectionRecord = [_sections objectAtIndex:indexPath.section];
        const NSUInteger row = indexPath.row;
        
        if (row < sectionRecord.numberOfRows) {
            CGFloat *rowHeights = sectionRecord.rowHeights;
            CGFloat offset = [self yw_offsetForSection:indexPath.section];
            
            offset += sectionRecord.headerHeight;
            
            for (NSInteger currentRow=0; currentRow<row; currentRow++) {
                offset += rowHeights[currentRow];
            }
            
            return [self yw_CGRectFromVerticalOffset:offset height:rowHeights[row]];
        }
    }
    
    return CGRectZero;
}
- (NSIndexPath *)yw_indexPathForRowAtPoint:(CGPoint)point
{
    NSArray *paths = [self yw_indexPathsForRowsInRect:CGRectMake(point.x,point.y,1,1)];
    return ([paths count] > 0)? [paths objectAtIndex:0] : nil;
}
- (NSArray *)yw_indexPathsForRowsInRect:(CGRect)rect{
    
    [self yw_updateSectionsCacheIfNeeded];
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    const NSInteger numberOfSections = [_sections count];
    CGFloat offset = _tableHeaderView? _tableHeaderView.frame.size.height : 0;
    
    for (NSInteger section=0; section<numberOfSections; section++) {
        YWTableViewSection *sectionRecord = [_sections objectAtIndex:section];
        CGFloat *rowHeights = sectionRecord.rowHeights;
        const NSInteger numberOfRows = sectionRecord.numberOfRows;
        
        offset += sectionRecord.headerHeight;
        
        if (offset + sectionRecord.rowsHeight >= rect.origin.y) {
            for (NSInteger row=0; row<numberOfRows; row++) {
                const CGFloat height = rowHeights[row];
                CGRect simpleRowRect = CGRectMake(rect.origin.x, offset, rect.size.width, height);
                
                if (CGRectIntersectsRect(rect,simpleRowRect)) {
                    [results addObject:[NSIndexPath indexPathForRow:row inSection:section]];
                } else if (simpleRowRect.origin.y > rect.origin.y+rect.size.height) {
                    break;
                }
                offset += height;
            }
        } else {
            offset += sectionRecord.rowsHeight;
        }
        
        offset += sectionRecord.footerHeight;
    }
    
    return results;
}

- (void)layoutSubviews
{
    _backgroundView.frame = self.bounds;
    [self yw_reloadDataIfNeeded];
    [self yw_layoutTableView];
    [super layoutSubviews];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self insertSubview:_backgroundView atIndex:0];
    }
}

@end
