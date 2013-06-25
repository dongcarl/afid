#include <stdio.h>
#include <stdlib.h> 
#include <string.h>



#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

#ifndef min
  #define min( a, b ) ( ((a) < (b)) ? (a) : (b) )
#endif
#ifndef nullchk
	#define nullchk(a) ((a==NULL) ? "NULL" : (a) )
#endif


//info defining single guesture
struct action {
   int * high;
   int * low;
   char* name;
};

// Action structures are stored in a linked list: each node contains an action (struct) and a pointer to the next action
//This means that in the functions, elements of an action are usually accessed through (ptr to node)->(action within node)->(element of action).
//It's a bit confusing, but you'll get the hang of it. 
struct actionNode {
   struct action * action;
   struct actionNode  *next;
};

struct actionNode * peter; //instantiation of the linked list (I don't know why we called it peter)

int b1=7;//digital pins 7 and 8 on the arduino are used as select pins to control the multiplexers
int b0=8;
int readings[10];//data from sensors
int * dims;//ordered list of dimensions, used to optimize
int * crosses;//ordered list of crosses in given dimension
int holding;  //if holding is 1, recognize will not call isaction. This prevents multiple instances of the same gesture from being printed
int * mctrs;  // [ctr for mat1, ctr for mat2], keeps track of current row in each matrix 
int ** mat1;  // ptr to array of ptrs (matrix), used in recognize_b
int ** mat2;  //used in recognize_b
char buffer[30];  //character buffer, stores previous gestures made
int  bufctr=0;  //


//@inputs action that was just added and weight to be given to it(mostly -1/1)
//finds the number of crosses created by a specific action adds them to crosses
//and sorts dims based on crosses

/*
  dimShift is used to calculate the optimal order of dimensions to check in the isAction function. It's based on the idea that it's best to check the dimensions with the smallest amount 
  of overlap between actions first, since a gesture is less likely to fall within the range for actions which it does not correspond to. This function uses the arrays dims[] and crosses[].
  It is called before an action is changed within addAction, so that the crosses (overlaps) due to that action can be removed, and then recalculated after the action has been updated. 
  dimShift takes a pointer to the action being changed, and a weight (-1 if you're removing the crosses due to that action, +1 if you're adding them). The pointer head used in the function is 
  moved through the list, so that each action in the list is compared with the input action.
*/
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

/*
  isAction is the function that does the actual recognizing. It takes a pointer to the linked list containing the actions, and the current vector of sensor values
  If current sensor values match any of the gestures in the linked list, isAction will print the gesture name (a char), and set holding to 1. If a gesture is not 
  recognized, isAction will return null.
*/
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

/*
  addAction receives a pointer to the linked list that holds the actions, along with the an input vector of sensor values, and a char specified by the user. 
  If there is already an action in the linked list associated with that char, addAction will update that action using the new sensor values. If there is no 
  action for that char, addAction will create a new action at the end of the linked list. It returns a pointer to the updated linked list. 
*/
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
/*
  recognize_b is called on every execution of the loop, and is used to determine if the user has been making a gesture (if their hand has not moved much for a while).
  The function uses two matrices to keep track of the sensor values needed. I'm not sure exactly what the time interval is betweeen the readings being compared, but it's very small. 
  If you wanted to change it, you could add more rows to avgmat2 (more rows means more time between the newest and oldest value stored in the matrix).
  Just keep in mind that the arduino has a finite amount of memory to store dynamic variables, and if you make these matrices too big, you might run out. 
  This is a function that I think you'll want to keep on the arduino after you move the processing to the application.
*/

void recognize_b(int *array, int **avgmat1, int **avgmat2, int *ctrs)
{
  int m;
  // set current row (val stored in ctr[0]) of avgmat1 equal to input array of sensor vals
  for (m=0; m<10; m++){
    avgmat1[ctrs[0]][m]=array[m];
  }
  (ctrs[0])=((ctrs[0])+1)%10; //update current row for avgmat1; val cycles from 0 to 9
  int x, y;
  if (ctrs[0]==0) {    // if avgmat1 has just been filled
    int avg[10];
    int j, k, sum;
    // average the rows of avgmat1
    for (j=0; j<10; j++){
      sum=0;
      for (k=0; k<10; k++){
        sum+=avgmat1[k][j];
      }
      avg[j]=sum/10;
    }   
    int tog=0; // if tog is still 0, isaction will be called
    int last=((ctrs[1]+1)%10); //find row of avgmat2 holding oldest average: this row will be the row ahead of the current row 
    
    for (m=0; m<10; m++){
      avgmat2[(ctrs[1])][m]=avg[m];  //set current row of avgmat2 to equal average of rows from avgmat1
      // check the difference between all of the values in the current row and last row
      if((avgmat2[(ctrs[1])][m]-avgmat2[last][m])>15){  // if any difference is greater than 15
        tog=1; //don't call isaction
        if((avgmat2[(ctrs[1])][m]-avgmat2[last][m])>25){ //if any difference is greater than 25
          holding=0;  //set holding to 0 so that isaction can be called the next time. 
        }
      }
    }
    if(tog==0&&holding==0){  //if the user has been maintaining a gesture (tog=0), and that gesture has not already been recognized (holding=0), call isAction
      isAction(peter,array);
    }
    (ctrs[1])=((ctrs[1])+1)%10;  // update current row for avgmat2
  }    
}
/*
  removeAction was supposed to be used to delete actions from the list. We haven't really used it at all because it didn't work too well. 
  Research said that free() doesn't really work on the arduino, which is probably why this didn't work.
*/
void removeAction(char name) {
	struct actionNode * point = peter;
	struct actionNode * point2;
        if(*point->action->name==name)
        {
           peter=point->next;
            free(point->action->high-1);
            free(point->action->low);
           free(point->action);
          free(point);
       return; 
        }
	while(point->next != NULL) {
		if (*point->next->action->name == name)
		{
			point2 = point;
			point->next = point2->next->next;
			free(point2->action->high);
			free(point2->action);
			free(point2);
			return;
		}
		point = point->next;
	}


}


void setup() {
  mat1=(int**)malloc(10*sizeof(int*)); //allocate space for mat1
  int ctr;
  for (ctr=0; ctr<10; ctr++){
    mat1[ctr]=(int*)calloc(10, sizeof(int));
  }
  buffer[0]='X';  //I think I put this here because it wouldn't work otherwise
  mat2=(int**)malloc(10*sizeof(int*)); //allocate space for mat2
  for (ctr=0; ctr<10; ctr++){
    mat2[ctr]=(int*)calloc(10, sizeof(int));
  }
  mctrs=(int*)calloc(2, sizeof(int));
  Serial.begin(9600);
  //to the best of my knowledge, the only pins currently in use are b0 and b1. I'm not sure why the other pins are being initialized. That can probably all be removed. 
  pinMode(6, INPUT);
  pinMode(7, OUTPUT);
  pinMode(11, 'output');
  pinMode(12, 'output');
  pinMode(10, 'output');
  digitalWrite(11,LOW);
  digitalWrite(10,LOW);
  digitalWrite(12,LOW);
  pinMode(b1, 'output');
  holding=0;
  pinMode(b0, 'output');
  
  delay(1000);
  Serial.flush();
}


void loop() {
  //get the current sensor values  
  digitalWrite(b1, LOW);
  digitalWrite(b0, LOW);
  readings[0]=analogRead(0);
  readings[1]=analogRead(2);
  readings[2]=analogRead(3);
  readings[3]=analogRead(4);
  
  digitalWrite(b0, HIGH);
  readings[4]=analogRead(0);
  readings[5]=analogRead(2);
  readings[6]=analogRead(3);
  readings[7]=analogRead(4);
  
  digitalWrite(b1, HIGH);
  digitalWrite(b0, LOW);
  readings[8]=analogRead(0);
  readings[9]=analogRead(2);
  
  if(Serial.available ()) {     //if there is serial data being sent from the serial monitor
    
    char ch = Serial.read();  //get the data
    
    if ((ch >='a') && (ch<='z')) {    //if it is a lowercase character, call addAction with that character and the current sensor data
      peter=addAction(peter, readings, ch);
      int i;
      //this loop prints out some of the data associated with the action just added. This can be removed.
      for(i=0;i<10;i++)
      {
        Serial.println(peter->action->high[i]);
      }
    }
    else if (ch=='=') {  //this was used to clear the screen of the serial monitor, along with the buffer.
      for (int i=0; i<50; i++)
      {
        Serial.println("\n");
      }
      int j;
      bufctr=0;
      for(j=0; j<20; j++){
        buffer[j]=' ';
      }
    }
    else if((ch >='A') && (ch<='Z')) {  //If the serial data is an uppercase character, call remove action on that letter. We didn't use this though. 
      ch = ch + 32;
      removeAction(ch);  //REMOVE ACTION DOES NOT WORK
    }
    else if(ch==' '){  // this was used to add a space character.
      peter=addAction(peter, readings, ch);
      int i;
      for(i=0;i<10;i++)
      {
        Serial.println(peter->action->high[i]);
      }
    }
    
  }
  
  recognize_b(readings, mat1, mat2, mctrs);  //recognize_b is called on every execution of the loop, using the current sensor values. 
}

