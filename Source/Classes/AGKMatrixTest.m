//
//  AGKMatrixTest.m
//  AGGeometryKit
//
//  Created by Logan Holmes on 7/15/14.
//  Copyright (c) 2014 Håvard Fossli. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AGKMatrix.h"

@interface AGKMatrixTest : XCTestCase
@end

@interface AGKMatrix ()
@property (nonatomic, assign) NSUInteger columnCount;
@property (nonatomic, assign) NSUInteger rowCount;

@property (nonatomic, strong) NSMutableArray *members;
@end

@implementation AGKMatrixTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDesignatedInitializer
{
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @4, @3, @2, @1]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    XCTAssertEqual(matrix.columnCount, 3, @"Resulting matrix does not have the right number of columns");
    XCTAssertEqual(matrix.rowCount, 4, @"Resulting matrix does not have the right number of rows");
    XCTAssertEqualObjects(matrix.members, members, @"Resulting matrix does not contain the passed in members plus default numbers");
}

- (void)testInit
{
    AGKMatrix *matrix = [[AGKMatrix alloc] init];
    
    XCTAssertEqual(matrix.columnCount, 0, @"Resulting matrix does not have the right number of columns");
    XCTAssertEqual(matrix.rowCount, 0, @"Resulting matrix does not have the right number of rows");
    XCTAssertEqualObjects(matrix.members, @[], @"Resulting matrix does not return an empty array as expected");
}

- (void)testFactoryMethodMatrix
{
    AGKMatrix *matrix = [AGKMatrix matrix];
    
    XCTAssertEqual(matrix.columnCount, 0, @"Resulting matrix does not have the right number of columns");
    XCTAssertEqual(matrix.rowCount, 0, @"Resulting matrix does not have the right number of rows");
    XCTAssertEqualObjects(matrix.members, @[], @"Resulting matrix does not return an empty array as expected");
}

- (void)testDefaultMember {
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:nil];
    
    XCTAssertEqualObjects(matrix.defaultMember, @0, @"Matrix should default to 0 by default");
    XCTAssertEqualObjects(matrix.members, @[], @"No members should have been set yet");
    XCTAssertEqualObjects([matrix objectAtColumnIndex:0 rowIndex:0], @0, @"Matrix should return the default value for any valid unfilled member position");
    
    matrix.defaultMember = @1;
    XCTAssertEqualObjects([matrix objectAtColumnIndex:0 rowIndex:0], @1, @"Matrix should substitute in the new defaultMember @1 for any valid unfilled member position");
}

- (void)testMatrixCompareIsEqual
{
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @4, @3, @2, @1]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    AGKMatrix *sameMatrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:@[@1, @2, @3, @4, @4, @3, @2, @1]];
    AGKMatrix *sameMatrixAgain = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:@[@1, @2, @3, @4, @4, @3, @2, @1, @0, @0, @0, @0]];
    AGKMatrix *differentMatrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:@[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1, @1]];
    
    XCTAssertEqualObjects(matrix, sameMatrix, @"Matrices should be equal");
    XCTAssertEqualObjects(matrix, sameMatrixAgain, @"Matrices should be equal");
    XCTAssertNotEqualObjects(matrix, differentMatrix, @"Matrices should not be equal");
    
}

- (void)testMatrixColumnCount
{
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:4 rows:3 members:members];
    
    XCTAssertEqual(matrix.columnCount, 4, @"Column count should be 4 regardless of how many members have been specified.");
}

- (void)testMatrixRowCount
{
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    XCTAssertEqual(matrix.rowCount, 4, @"Row count should be 4 regardless of how many members have been specified.");
}

- (void)testMatrixTotalCount
{
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @4, @3, @2, @1]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    XCTAssertEqual(matrix.count, (3 * 4), @"Count should be columns times rows, or 12 in the case of a 3x4 matrix.");
    
    matrix.columnCount += 1;
    XCTAssertEqual(matrix.count, (4 * 4), @"Count should return the total number of spots in the matrix based on the specified row and column dimensions.");
}

#pragma mark - Accessing Members, Columns and Rows

- (void)testObjectAtColumnIndexRowIndex
{
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSNumber *member = [matrix objectAtColumnIndex:1 rowIndex:1];
    XCTAssertEqualObjects(member, @6, @"Column/Row indexes are not returning the correct member");
}

- (void)testColumns {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSArray *columns = matrix.columns;
    NSArray *comparisonArray = @[@[@1, @2, @3, @4], @[@5, @6, @7, @8], @[@0, @0, @0, @0]];
    
    XCTAssertEqual(columns.count, comparisonArray.count, @"Columns method is not returning the correct number of column arrays.");
    for (NSUInteger index = 0; index < columns.count; index++) {
        XCTAssert([(NSArray *)columns[index] isEqualToArray:comparisonArray[index]], @"Returned column at index %d should be: %@", index, comparisonArray[index]);
    }
}

- (void)testRows {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSArray *rows = matrix.rows;
    NSArray *comparisonArray = @[@[@1, @5, @0], @[@2, @6, @0], @[@3, @7, @0], @[@4, @8, @0]];
    
    XCTAssertEqual(rows.count, comparisonArray.count, @"Rows method is not returning the correct number of row arrays.");
    for (NSUInteger index = 0; index < rows.count; index++) {
        XCTAssert([(NSArray *)rows[index] isEqualToArray:comparisonArray[index]], @"Returned row at index %d should be: %@", index, comparisonArray[index]);
    }
}

- (void)testColumnAtIndex {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSArray *comparisonColumn = @[@5, @6, @7, @8];
    NSArray *column = [matrix columnAtIndex:1];
    XCTAssert([column isEqualToArray:comparisonColumn], @"Column 1 should be %@", comparisonColumn);
}

- (void)testRowAtIndex {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSArray *comparisonColumn = @[@2, @6, @0];
    NSArray *column = [matrix rowAtIndex:1];
    XCTAssert([column isEqualToArray:comparisonColumn], @"Row 1 should be %@", comparisonColumn);
}

- (void)testObjectAtIndexedSubscript {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    XCTAssertEqualObjects(matrix[2], @3, @"Subscripting should access the matrix as an index list of column first members.");
    XCTAssertEqualObjects(matrix[8], matrix.defaultMember, @"Subscripting should return the default value if no other value has been specified.");
}

- (void)testEnumerateMembersUsingBlock {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    __block NSUInteger defaultValuesRecieved = 0;
    [matrix enumerateMembersUsingBlock:^(NSNumber *member, NSUInteger index, NSUInteger columnIndex, NSUInteger rowIndex, BOOL *stop) {
        XCTAssertEqual(columnIndex, index / 4, @"Column index should be %d for absolute index %d on a 3x4 matrix", index / 4, index);
        XCTAssertEqual(rowIndex, index % 4, @"Row index should be %d for absolute index %d on a 3x4 matrix", index % 4, index);
        
        if (index < members.count) {
            XCTAssertEqualObjects(member, members[index], @"The returned member should be the same as the one passed in: %@", members[index]);
        } else {
            defaultValuesRecieved++;
            if (defaultValuesRecieved < 3) {
                XCTAssertEqualObjects(member, matrix.defaultMember, @"Member at index %d has not been assigned yet, and therefore should return the default member: %@", index, matrix.defaultMember);
                if (defaultValuesRecieved > 1) {
                    *stop = YES;
                }
            } else {
                XCTAssertEqual(*stop, YES, @"The stop argument should have been set to YES");
                XCTFail(@"The stop argument has been set to YES, and should have stopped execution of the block");
            }
        }
    }];
}

- (void)testEnumerateColumnsUsingBlock {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:4 rows:4 members:members];
    
    NSArray *comparisonArray = @[@[@1, @2, @3, @4], @[@5, @6, @7, @8], @[@0, @0, @0, @0], @[@0, @0, @0, @0], @[@0, @0, @0, @0]];
    [matrix enumerateColumnsUsingBlock:^(NSArray *column, NSUInteger columnIndex, BOOL *stop) {
        if (columnIndex < 2) {
            XCTAssertEqualObjects(column, comparisonArray[columnIndex], @"Column %d should be the same as comparisonArray[%d]: %@", columnIndex, columnIndex, comparisonArray[columnIndex]);
        } else if (columnIndex < 4) {
            NSNumber *defaultMember = matrix.defaultMember;
            NSArray *defaultArray = @[defaultMember, defaultMember, defaultMember, defaultMember];
            XCTAssertEqualObjects(column, defaultArray, @"Column %d should generate an array of default members equal to the number of rows: @%@ x 4", columnIndex, defaultMember);
            
            if (columnIndex == 3) {
                *stop = YES;
            }
        } else {
            XCTAssertEqual(*stop, YES, @"The stop argument should have been set to YES");
            XCTFail(@"The stop argument has been set to YES, and should have stopped execution of the block");
        }
    }];
}

- (void)testEnumerateRowsUsingBlock {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSArray *comparisonArray = @[@[@1, @5, @0], @[@2, @6, @0], @[@3, @7, @0], @[@4, @8, @0]];
    [matrix enumerateRowsUsingBlock:^(NSArray *row, NSUInteger rowIndex, BOOL *stop) {
        if (rowIndex) {
            XCTAssertEqualObjects(row, comparisonArray[rowIndex], @"Row %d should be the same as comparisonArray[%d]: %@", rowIndex, rowIndex, comparisonArray[rowIndex]);
        }
    }];
}

#pragma mark - Adding Members, Columns and Rows

- (void)testSetObjectAtColumnIndexRowIndex {
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:0 rows:0 members:nil];
    
    [matrix setObject:@11 atColumnIndex:0 rowIndex:0];
    XCTAssertEqualObjects([matrix objectAtColumnIndex:0 rowIndex:0], @11, @"Member at 0x0 should be 11");
    
    [matrix setObject:@31 atColumnIndex:2 rowIndex:0];
    XCTAssertEqualObjects([matrix objectAtColumnIndex:1 rowIndex:0], matrix.defaultMember, @"Member at unspecified location 1x0 should be the defaultMember: %@", matrix.defaultMember);
    XCTAssertEqualObjects([matrix objectAtColumnIndex:2 rowIndex:0], @31, @"Member at 2x0 should be 31");
    
    [matrix setObject:@34 atColumnIndex:2 rowIndex:3];
    XCTAssertEqualObjects([matrix objectAtColumnIndex:2 rowIndex:0], @31, @"Member at 2x0 should be 31 even after expanding the array");
    XCTAssertEqualObjects([matrix objectAtColumnIndex:0 rowIndex:3], @0, @"Member at unspecified location 0x3 should be the defaultMember: %@", matrix.defaultMember);
    XCTAssertEqualObjects([matrix objectAtColumnIndex:2 rowIndex:3], @34, @"Member at 2x3 should be 34 even after");
}

- (void)testSetColumnAtIndexWithArray {
    NSMutableArray *members = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4, @5, @6, @7, @8]];
    AGKMatrix *matrix = [[AGKMatrix alloc] initWithColumns:3 rows:4 members:members];
    
    NSArray *fourthColumn = @[@9, @9, @9, @9];
    [matrix setColumnAtIndex:3 withArray:fourthColumn];
    XCTAssertEqualObjects([matrix columnAtIndex:3], fourthColumn, @"A fourth column at index 3 should have been added with members: %@", fourthColumn);
    
    [matrix setColumnAtIndex:1 withArray:@[@10]];
    for (NSUInteger rowIndex = 0; rowIndex < 4; rowIndex++) {
        if (rowIndex == 0) {
            XCTAssertEqualObjects([matrix objectAtColumnIndex:1 rowIndex:rowIndex], @10, @"Member at 1x%d should have been replaced with 10", rowIndex);
        } else {
            XCTAssertEqualObjects([matrix objectAtColumnIndex:1 rowIndex:rowIndex], matrix.defaultMember, @"Member at 1x%d should return the defaultMember, as that postion was not specified.", rowIndex);
        }
    }
    
    [matrix setColumnAtIndex:4 withArray:@[@11, @12, @13, @14, @15]];
    XCTAssertEqual(matrix.rowCount, 5, @"Matrix should have expanded to fit the incoming column array");
    XCTAssertEqualObjects([matrix objectAtColumnIndex:4 rowIndex:4], @15, @"Member at 4x4 should return the new member 15.");
    XCTAssertEqualObjects([matrix objectAtColumnIndex:3 rowIndex:4], matrix.defaultMember, @"Member at 3x4 should return the defaultMember, as that postion was not specified before the matrix expansion.");
}

@end
