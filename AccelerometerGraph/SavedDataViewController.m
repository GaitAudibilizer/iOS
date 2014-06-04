//
//  SavedDataViewController.m
//  GaitAudibilizer
//
//  Created by Ian Garcia-Doty on 6/3/14.
//
//

#import "SavedDataViewController.h"

@interface SavedDataViewController ()

@end

@implementation SavedDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dataArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil] retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [dataArray count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSArray *fileListAct = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
//    dataArray = fileListAct;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[dataArray objectAtIndex:indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(NSString*)filePath{
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    NSLog(@"%@",path);
    return path;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //Delete row from view
        
        
        //Delete csv file
        
        NSString *fileName=[dataArray objectAtIndex:indexPath.row];
        NSError *error=nil;
        NSString *pathToDelete=[[self filePath]stringByAppendingPathComponent:fileName];
        BOOL succes=[[NSFileManager defaultManager]removeItemAtPath:pathToDelete error:&error];
        
        if (error) {
            NSLog(@"ERROR: %@",error);
        }
        
        if (succes) {
            //remove this item from array
            [dataArray removeObjectAtIndex:indexPath.row];
            //and remove cell
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Alert!" message:@"File can not be deleted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    int selectedRow = indexPath.row;
    NSLog(@"touch on row %d", selectedRow);
}

-(void)dealloc
{
	// clean up everything.
    [dataArray dealloc];
	[super dealloc];
}

@end
