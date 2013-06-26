//
//  SDGestureRecognizer.m
//  squid-cli
//
//  Created by Carl Dong on 6/25/13.
//  Copyright (c) 2013 catswearingbreadhats. All rights reserved.
//

#import "SDGestureRecognizer.h"

@implementation SDGestureRecognizer

void dimShift(struct actionNode * ptr,int weight)
{
	struct actionNode *head=peter; //get pointer to first action in linked list. This pointer will be shifted through the list.
  	int i,j,m,minat,temp;
	if(dims==NULL) //if this is the first time dimShift has been called
	{
        //initialize dims and crosses
		dims=(int*)malloc(sizeof(int)*10);
		for(i=0;i<10;i++)
		{
			dims[i]=i;
		}
		crosses=(int*)calloc(10,sizeof(int));
        
	}
    //Move through the linked list to check the overlap of each action with the input action
	while(head!=NULL)
	{
		if(head==ptr)  //if the pointer to the action in the list is the same as the pointer to the input action,
		{
			head=head->next;  //skip it
			continue;
		}
		for(i=0;i<10;i++)  //for each dimension
		{
			if((head->action->high[dims[i]]<ptr->action->low[dims[i]])||(head->action->low[dims[i]]>ptr->action->high[dims[i]]))  //if the range for the input action in that dimension overlaps the range for the action in the list
			{
				crosses[i]=crosses[i]+weight;  //increment (or decrement, if weight=-1) crosses for that dimension
			}
		}
		head=head->next; //check the next action in the list
	}
    //order dimensions according to the least number of crosses, store the order in dims.
	for(i=0;i<10;i++)
	{
		m=crosses[i];
		minat=i;
		for(j=(i+1);j<10;j++)
		{
			if(m>crosses[j])
			{
				m=crosses[j];
				minat=j;
			}
		}
		temp=dims[i];
		dims[i]=minat;
		dims[minat]=temp;
		crosses[minat]=crosses[i];
		crosses[i]=m;
	}
}

char isAction(struct actionNode *ptr, int a[10])
{
	int i,j;
	int outside;
    struct actionNode *ptr2=ptr;   //make a copy of the pointer to the first element in the linked list.
    int h=0;
    
    // Move through the linked list to check the gestures stored in it
	while(ptr!=NULL)  //While we haven't reached the end of the linked list
	{
		outside=0; // if outside is still 0 after all dimensions have been checked for a specific action, then that action is returned
		for(i=0;i<10;i++)  //for each dimension
		{
			j=dims[i]; // check dimensions in order given in dims; e.g. check the 3rd dimension first, the 7th dimension second, etc. this order is calculated using dimshift
            //check to see if the input vector is outside the range for the current action in the current dimension
			if((ptr->action->high[j]<a[j])||(ptr->action->low[j]>a[j]))
			{
                //if it is mark guesture wrong and move on
				outside=1;
				break;
			}
		}
        //if guesture is never marked wrong:
		if(!outside)
		{
            //Update the buffer and print it:
            int xx;
            if (bufctr==19){
                for (xx=0; xx<19; xx++){
                    buffer[xx]=buffer[xx+1];
                }
                buffer[19]=*ptr->action->name;
            }
            else {
                buffer[bufctr]=*ptr->action->name;
                bufctr++;
            }
            //print blank lines to clear serial monitor before printing buffer: this is just for aesthetics
            for (int i=0; i<50; i++)
            {
                Serial.println("\n");
            }
            for (xx=0; xx<20; xx++){
                Serial.print(buffer[xx]);
            }
            Serial.print("\n");
            
            //Serial.println(*ptr->action->name);
            holding=1;
            
            if(ptr2!=ptr)  // if the current action is not the first action in the linked list
            {
                //swap the current action with the action before it (priority linked list)
                struct action *temp=ptr->action;
                ptr->action=ptr2->action;
                ptr2->action=temp;
            }
			return *ptr2->action->name;
            
            
		}
        ptr2=ptr;  // hold onto current pointer
		ptr=ptr->next;  // get pointer to next action in linked list
	}
	return NULL;
}

struct actionNode * addAction(struct actionNode * ptr, int a[10], char name)
{
	struct actionNode * rtn=ptr; //hold onto pointer to the first element of the list: this gets returned
	struct actionNode * ptr2;
	int i;
	holding=1;  //make sure the arduino does not output the same gesture that was just added
	//Move through the linked list to see if there is an action that matches the input char
	while(ptr!=NULL)
	{
		//check to see if the name of the current action is the same as the input char
		if(*ptr->action->name==name)
		{
            //if it is:
            dimShift(ptr,-1); // recalculate crosses without current action, because we are changing it
            // for each dimension, if value in input array +-10 is outside of range for this action, change max or min
            for(i=0;i<10;i++)
            {
                
                ptr->action->low[i]=min(ptr->action->low[i],a[i]-10);
                ptr->action->high[i]=max(ptr->action->high[i],a[i]+10);
                
                
            }
            //recalculate crosses again with new mins and maxes.
            dimShift(ptr,1);
            return rtn;
		}
		ptr2=ptr;
		ptr=ptr->next;
	}
	// if input char is not associated with any existing actions, create new action in new node at end of list
	ptr=(struct actionNode *)malloc(sizeof(struct actionNode *));  //after while loop, ptr should point to end of list (NULL)
	ptr->action=(struct action *)malloc(sizeof(struct action *));
	ptr->next=NULL;
	ptr->action->high=(int*)malloc(11*sizeof(int));
    ptr->action->high=ptr->action->high+1;  //I don't know why this was done. Sorry!
	ptr->action->low=(int*)malloc(10*sizeof(int));
	for(i=0;i<10;i++)  //create mins and maxes from the input vector, adding/subtracting 10 to create range
	{
		ptr->action->low[i]=a[i]-10;
		ptr->action->high[i]=a[i]+10;
	}
    ptr->action->name=(char*)malloc(sizeof(char));
	*ptr->action->name=name;
	if(rtn==NULL) //if list was empty before addition of new action
	{
		rtn=ptr;  //return pointer to new action
	}
	else
	{
		ptr2->next=ptr;  //put the new action at the end of the list
	}
	dimShift(ptr,1);  //recalculate order of dimensions to check in isAction
	return rtn;
}


- (void)initialize
{
    b1 = 7;//digital pins 7 and 8 on the arduino are used as select pins to control the multiplexers
    b0 = 8;
    
    bufctr = 0;  //

    
    
    mat1=(int**)malloc(10*sizeof(int*)); //allocate space for mat1
    int ctr;
    for (ctr=0; ctr<10; ctr++)
    {
        mat1[ctr]=(int*)calloc(10, sizeof(int));
    }
    
    
    buffer[0]='X';  //I think I put this here because it wouldn't work otherwise
    
    
    mat2=(int**)malloc(10*sizeof(int*)); //allocate space for mat2
    for (ctr=0; ctr<10; ctr++)
    {
        mat2[ctr]=(int*)calloc(10, sizeof(int));
    }
    
    
    mctrs=(int*)calloc(2, sizeof(int));
//    Serial.begin(9600);
//    //to the best of my knowledge, the only pins currently in use are b0 and b1. I'm not sure why the other pins are being initialized. That can probably all be removed.
//    pinMode(6, INPUT);
//    pinMode(7, OUTPUT);
//    pinMode(11, 'output');
//    pinMode(12, 'output');
//    pinMode(10, 'output');
//    digitalWrite(11,LOW);
//    digitalWrite(10,LOW);
//    digitalWrite(12,LOW);
//    pinMode(b1, 'output');
//    holding=0;
//    pinMode(b0, 'output');
//    
//    delay(1000);
//    Serial.flush();
}

- (void)keepRecognizing:(NSArray *)poppedReadings
{
//    //get the current sensor values
//    digitalWrite(b1, LOW);
//    digitalWrite(b0, LOW);
//    readings[0]=analogRead(0);
//    readings[1]=analogRead(2);
//    readings[2]=analogRead(3);
//    readings[3]=analogRead(4);
//    
//    digitalWrite(b0, HIGH);
//    readings[4]=analogRead(0);
//    readings[5]=analogRead(2);
//    readings[6]=analogRead(3);
//    readings[7]=analogRead(4);
//    
//    digitalWrite(b1, HIGH);
//    digitalWrite(b0, LOW);
//    readings[8]=analogRead(0);
//    readings[9]=analogRead(2);
    
    for (int i = 0; i < [poppedReadings count]; i++)
    {
        readings[i] = (int)[poppedReadings objectAtIndex:i];
    }
    
//    if(Serial.available ()) {     //if there is serial data being sent from the serial monitor
//        
//        char ch = Serial.read();  //get the data
//        
//        if ((ch >='a') && (ch<='z')) {    //if it is a lowercase character, call addAction with that character and the current sensor data
//            peter=addAction(peter, readings, ch);
//            int i;
//            //this loop prints out some of the data associated with the action just added. This can be removed.
//            for(i=0;i<10;i++)
//            {
//                Serial.println(peter->action->high[i]);
//            }
//        }
//        else if (ch=='=') {  //this was used to clear the screen of the serial monitor, along with the buffer.
//            for (int i=0; i<50; i++)
//            {
//                Serial.println("\n");
//            }
//            int j;
//            bufctr=0;
//            for(j=0; j<20; j++){
//                buffer[j]=' ';
//            }
//        }
//        else if((ch >='A') && (ch<='Z')) {  //If the serial data is an uppercase character, call remove action on that letter. We didn't use this though.
//            ch = ch + 32;
//            removeAction(ch);  //REMOVE ACTION DOES NOT WORK
//        }
//        else if(ch==' '){  // this was used to add a space character.
//            peter=addAction(peter, readings, ch);
//            int i;
//            for(i=0;i<10;i++)
//            {
//                Serial.println(peter->action->high[i]);
//            }
//        }
//        
//    }
    
    recognize_b(readings, mat1, mat2, mctrs);  //recognize_b is called on every execution of the loop, using the current sensor values.
}

@end
