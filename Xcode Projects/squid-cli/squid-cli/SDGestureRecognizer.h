//
//  SDGestureRecognizer.h
//  squid-cli
//
//  Created by Carl Dong on 6/25/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import <Foundation/Foundation.h>


#ifndef max
#define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef min
#define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif
#ifndef nullchk
#define nullchk(a) ((a==NULL) ? "NULL" : (a) )
#endif




@interface SDGestureRecognizer : NSObject
{

//info defining single guesture
struct action
{
    int * high;
    int * low;
    char* name;
};

// Action structures are stored in a linked list: each node contains an action (struct) and a pointer to the next action
//This means that in the functions, elements of an action are usually accessed through (ptr to node)->(action within node)->(element of action).
//It's a bit confusing, but you'll get the hang of it.
struct actionNode
{
    struct action * action;
    struct actionNode  *next;
};

struct actionNode * peter; //instantiation of the linked list (I don't know why we called it peter)

    int b1;//digital pins 7 and 8 on the arduino are used as select pins to control the multiplexers
    int b0;
    int readings[10];//data from sensors
    int * dims;//ordered list of dimensions, used to optimize
    int * crosses;//ordered list of crosses in given dimension
    int holding;  //if holding is 1, recognize will not call isaction. This prevents multiple instances of the same gesture from being printed
    int * mctrs;  // [ctr for mat1, ctr for mat2], keeps track of current row in each matrix
    int ** mat1;  // ptr to array of ptrs (matrix), used in recognize_b
    int ** mat2;  //used in recognize_b
    char buffer[30];  //character buffer, stores previous gestures made
    int  bufctr;  //

}
- (void)keepRecognizing;

@end
