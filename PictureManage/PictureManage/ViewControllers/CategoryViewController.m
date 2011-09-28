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
    
    UIBarButtonItem *leftBarItem  = [[UIBarButtonItem alloc]initWithTitle:@"新分组" style:UIBarButtonSystemItemAdd target:self action:@selector(addCategory)];
    
    self.navigationItem.rightBarButtonItem = leftBarItem;
    [leftBarItem release];
    
    
    
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

-(void)toggleMove{
    [_tableView setEditing:!_tableView.editing animated:YES];
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
    
    UIButton *buttonUpdate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonUpdate setTitle:@"修改" forState:UIControlStateNormal];
    [buttonUpdate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonUpdate addTarget:self action:@selector(doUpdate:) forControlEvents:UIControlEventTouchUpInside];
    buttonUpdate.tag  = indexPath.row;
    [buttonUpdate setFrame:CGRectMake(191, 5, 55, 35)];
    [cell.contentView addSubview:buttonUpdate];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView  
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle  
forRowAtIndexPath:(NSIndexPath *)indexPath  
{ 
    
    [self doDelete:indexPath.row];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  
{ 
    return UITableViewCellEditingStyleNone; 
} 





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   
}






-(void)doUpdate:(id)sender{
    
}

-(void)doDelete:(NSInteger)index{
    categoryIndex = index;

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
