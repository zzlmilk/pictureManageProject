//
//  CategoryViewController.m
//  PictureManage
//
//  Created by uzai on 11-8-27.
//  Copyright 2011年 UZAI. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryEditViewController.h"
#import "CategoryDataSource.h"

@implementation CategoryViewController

- (void)dealloc
{
    [_tableView release];
    [_categorys release];

    [super dealloc];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    
    [self.view addSubview:_tableView];
   // _categorys = [[NSMutableArray alloc]initWithObjects:@"时尚",@"风景",@"安吉漂流", nil];
    UIBarButtonItem *rightBarItem  = [[UIBarButtonItem alloc]initWithTitle:@"新分组" style:UIBarButtonSystemItemAdd target:self action:@selector(addCategory)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [rightBarItem release];
    
           
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

        self.navigationItem.title = @"分类管理";
    self.navigationController.navigationBarHidden = NO;
    [_categorys removeAllObjects];
    _categorys = nil;
    [_categorys release];
     _categorys = [[CategoryDataSource categorys] retain]; 
    [_tableView reloadData];
}

-(void)addCategory{
    CategoryEditViewController *categortEditViewController = [[CategoryEditViewController alloc]init];
    [self.navigationController pushViewController:categortEditViewController animated:YES];
    [categortEditViewController release];
    
}



#pragma mark - tableView DataSource and Degelate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_categorys count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"catagoryCellId";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==nil){
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    
    cell.textLabel.text = [_categorys objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIButton *buttonDelete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonDelete setTitle:@"删除" forState:UIControlStateNormal];
    [buttonDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDelete addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    buttonDelete.tag  = indexPath.row;
    [buttonDelete setFrame:CGRectMake(220, 2, 60, 40)];
    [cell.contentView addSubview:buttonDelete];
    return cell;
}




-(void)doDelete:(id)sender{
    categoryIndex = [sender tag];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除分类" message:@"确认要删除这个分类吗？\n此分类下的照片也将一并被删除。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    [alert release];
    
    
         
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //确认删除，执行删除操作
    if (buttonIndex == 1) {
        NSString *cagegoryName = [_categorys objectAtIndex:categoryIndex];
        if([CategoryDataSource delegeCategoryByName:cagegoryName]){
            [_categorys removeAllObjects];
            _categorys = [[CategoryDataSource categorys] retain]; 
            [_tableView reloadData];
        }

    }
  }

@end
