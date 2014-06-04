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
    
    //Add share button on top right corner
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(emailFiles)];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //Get filepaths
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    dataArray = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil] retain];
    
    //Create an array to track which items are checked
    selectedArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < dataArray.count; ++i)
    {
        [selectedArray addObject:[NSNumber numberWithBool:NO]];
    }
}

-(void)emailFiles{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Gait data from GaitAudibilizer"];
    
    // Attach an image to the email
    NSData*myData = nil;
    
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
    
    // Fill out the email body text
    NSString *emailBody = @"Gait data is attached as csv files. The first 3 columns are x,y, and z acceleration in g's and\
    the last column is angular acceleration about z (rad/s)";
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:picker animated:YES];

    [picker release];
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
    
    //Add checkmark when touched
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }else {
        newCell.accessoryType = UITableViewCellAccessoryNone;
        [selectedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)dealloc
{
	// clean up everything.
    [dataArray dealloc];
	[super dealloc];
}

@end
